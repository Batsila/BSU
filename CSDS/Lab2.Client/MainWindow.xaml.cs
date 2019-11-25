using Lab2.Common.Helpers;
using Lab2.Common.Models;
using Lab2.Common.Security;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Windows;
using System.Windows.Media;

namespace Lab2.Client
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly HttpClient _client;
        private string _token;
        private byte[] _sessionKey;
        private byte[] _sessionIV;

        private string _garbage = string.Empty;

        public MainWindow()
        {
            _client = new HttpClient();
            _client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));
            InitializeComponent();
        }

        private void BtnConnect_Click(object sender, RoutedEventArgs e)
        {
            var authSessionRequest = new AuthSessionRequest
            {
                Login = TxtLogin.Text
            };

            var json = JsonConvert.SerializeObject(authSessionRequest);

            var request = new HttpRequestMessage
            {
                RequestUri = new Uri($"http://localhost:5000/api/session"),
                Method = HttpMethod.Post,
                Content = new StringContent(json, Encoding.UTF8, "application/json")
            };

            HttpResponseMessage response = _client.SendAsync(request).Result;

            if (!response.IsSuccessStatusCode)
            {
                AuthStatus.Text = "not authorized";
                AuthStatus.Foreground = new SolidColorBrush(Colors.Red);
                return;
            }

            var authSessionResponse = JsonConvert.DeserializeObject<AuthSessionResponse>(
                response.Content.ReadAsStringAsync().Result);

            var authRequest = new AuthRequest
            {
                Login = TxtLogin.Text
            };

            var keyString = string.Empty;
            var keyInputDialog = new KeyInputDialog();
            if (keyInputDialog.ShowDialog() == true)
            {
                keyString = keyInputDialog.Key;
            }

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                RSA.ImportParameters(authSessionResponse.PublicRSAParameters.ToRSAParameters());
                authRequest.EncryptedPassword = RSA.Encrypt(Encoding.Default.GetBytes(TxtPassword.Text), false);
                authRequest.EncryptedTelegramKey = RSA.Encrypt(Encoding.Default.GetBytes(keyString), false);
            }

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                authRequest.ClientPublicRSAParameters = RSA.ExportParameters(false).ToPublicRSAParameters();

                json = JsonConvert.SerializeObject(authRequest);

                request = new HttpRequestMessage
                {
                    RequestUri = new Uri($"http://localhost:5000/api/auth"),
                    Method = HttpMethod.Post,
                    Content = new StringContent(json, Encoding.UTF8, "application/json")
                };

                response = _client.SendAsync(request).Result;

                if (!response.IsSuccessStatusCode)
                {
                    AuthStatus.Text = "not authorized";
                    AuthStatus.Foreground = new SolidColorBrush(Colors.Red);
                    return;
                }

                var authResponse = JsonConvert.DeserializeObject<AuthResponse>(
                response.Content.ReadAsStringAsync().Result);

                _token = authResponse.Token;

                _sessionKey = RSA.Decrypt(authResponse.EncryptedSessionKey, false);
                _sessionIV = RSA.Decrypt(authResponse.EncryptedSessionIV, false);

                AuthStatus.Text = "authorized";
                AuthStatus.Foreground = new SolidColorBrush(Colors.Green);
            }

            _garbage = string.Empty;
        }

        private void BtnLoad_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrEmpty(_token))
            {
                MessageBox.Show("Not Authorized");
                return;
            }

            var content = new ContentWeb
            {
                Garbage = _garbage
            };

            var json = JsonConvert.SerializeObject(content);

            var message = JsonConvert.SerializeObject(AES.EncryptStringToBytes_Aes(json, _sessionKey, _sessionIV));

            var request = new HttpRequestMessage
            {
                RequestUri = new Uri($"http://localhost:5000/api/content"),
                Method = HttpMethod.Post,
                Content = new StringContent(message, Encoding.UTF8, "application/json")
            };
            request.Headers.Add("Authorization", $"Bearer {_token}");

            HttpResponseMessage response = _client.SendAsync(request).Result;

            if (!response.IsSuccessStatusCode)
            {
                EncryptedMessage.Text = string.Empty;
                DecryptedText.Text = string.Empty;
                MessageBox.Show("Can not get content");
                return;
            }

            message = response.Content.ReadAsStringAsync().Result;
            var r = JsonConvert.DeserializeObject<ContentResponse>(message);

            var responseStr = AES.DecryptStringFromBytes_Aes(r.Data, _sessionKey, _sessionIV);

            var contentWeb = JsonConvert.DeserializeObject<ContentWeb>(responseStr);

            EncryptedMessage.Text = message;

            DecryptedText.Text = contentWeb.Data;

            _garbage = contentWeb.Garbage;
        }

        private void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrEmpty(_token))
            {
                MessageBox.Show("Not Authorized");
                return;
            }

            var content = new ContentWeb
            {
                Garbage = _garbage,
                Data = InputText.Text
            };

            var json = JsonConvert.SerializeObject(content);

            var message = JsonConvert.SerializeObject(AES.EncryptStringToBytes_Aes(json, _sessionKey, _sessionIV));

            var request = new HttpRequestMessage
            {
                RequestUri = new Uri($"http://localhost:5000/api/content"),
                Method = HttpMethod.Patch,
                Content = new StringContent(message, Encoding.UTF8, "application/json")
            };
            request.Headers.Add("Authorization", $"Bearer {_token}");

            HttpResponseMessage response = _client.SendAsync(request).Result;

            if (!response.IsSuccessStatusCode)
            {
                MessageBox.Show("Can not save content");
                return;
            }

            message = response.Content.ReadAsStringAsync().Result;
            var r = JsonConvert.DeserializeObject<ContentResponse>(message);

            var responseStr = AES.DecryptStringFromBytes_Aes(r.Data, _sessionKey, _sessionIV);

            var contentWeb = JsonConvert.DeserializeObject<ContentWeb>(responseStr);

            _garbage = contentWeb.Garbage;
        }
    }
}
