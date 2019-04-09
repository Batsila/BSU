animation = function () {
    var modal = document.getElementById('testModal');
    var modalImg = document.getElementById("testModalImg");
    var captionText = document.getElementById("caption");
    document.body.addEventListener('click', function (event) {
        if(event.target.className === "postImg") {
            var img = event.target;
            modal.style.display = "block";
            modalImg.src = img.src;
            captionText.innerHTML = img.alt;
            var span = document.getElementsByClassName("close")[0];
            span.onclick = function () {
                modal.style.display = "none";
            }
        }
    });
};
document.addEventListener("DOMContentLoaded", animation);