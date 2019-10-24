using Lab2.Common.Helpers;
using Lab2.Common.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Lab2.Client
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly HttpClient _client;
        private string _token;
        private string _sessionKey;

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

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                RSA.ImportParameters(authSessionResponse.PublicRSAParameters.ToRSAParameters());
                authRequest.EncryptedPassword = RSA.Encrypt(Encoding.Default.GetBytes(TxtPassword.Text), false);
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

                var keyBytes = RSA.Decrypt(authResponse.EncryptedSessionKey, false);
                _sessionKey = Encoding.Default.GetString(keyBytes);

                AuthStatus.Text = "authorized";
                AuthStatus.Foreground = new SolidColorBrush(Colors.Green);
            }
        }
    }
}
