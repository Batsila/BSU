var view = (function () {
    var userName = localStorage.getItem('username');
    var skip = 0;
    var top = 6;
    var filterConfig = {};
    filterConfig.tags = [];
    filterConfig.authors = [];

    function showStatus() {
        var status =  document.getElementById('status');
        if(userName) {
            status.innerHTML = '<li class = "logo"><a>FotoGram<i class="fas fa-camera-retro"></i></a></li>' +
                '<li class = "status"><a id = "log-out">Log Out</a></li>' +
                '<li class = "status"><a>'+ userName +'<i class="fas fa-user"></i></a></li>' +
                '<li class = "status"><a id = "add-post"><i class="fas fa-plus"></i> New Post</a></li>';
        }
        else {
            status.innerHTML = '<li class = "logo"><a>FotoGram<i class="fas fa-camera-retro"></i></a></li>' +
                '<li class = "status"><a id = "log-in">Log In</a></li>';
        }
    }

    function showPost(postInfo) {
        var figure = document.createElement('figure');
        figure.id = postInfo.id;
        var post = document.createElement('div');
        post.className = 'post';
        var img = document.createElement('img');
        img.className = 'postImg';
        img.id = postInfo.id;
        img.src = postInfo.photoLink;
        img.alt = postInfo.description;
        post.appendChild(img);
        var info = document.createElement('div');
        info.className = 'info';
        var likes = document.createElement('div');
        likes.className = 'likes';
        likes.id = postInfo.id;
        if(postInfo.likes.indexOf(userName) === -1) {
            likes.innerHTML = '<i class="fas fa-heart"></i> ' + '<span>' + postInfo.likes.length + '</span>';;
        }
        else {
            likes.innerHTML = '<i class="fas fa-heart active"></i> ' + '<span>' + postInfo.likes.length + '</span>';
        }
        var author = document.createElement('div');
        author.className = 'author';
        author.innerHTML = postInfo.createdAt.getDate() + ':' + (postInfo.createdAt.getMonth() + 1) + ':' + postInfo.createdAt.getFullYear() + ' ' + postInfo.author;
        info.appendChild(likes);
        info.appendChild(author);
        post.appendChild(info);
        figure.appendChild(post);
        var description = document.createElement('div');
        description.className = 'description';
        description.innerHTML = postInfo.description;
        figure.appendChild(description);
        var tags = document.createElement('div');
        tags.className = 'tags';
        for(var i = 0; i < postInfo.tags.length; ++i) {
            var tag = document.createElement('a');
            tag.innerHTML = '#' + postInfo.tags[i];
            tags.appendChild(tag);
        }
        figure.appendChild(tags);
        if(userName === postInfo.author) {
            var tools = document.createElement('div');
            tools.className = 'tools';
            tools.innerHTML = '<button class = "edit"><i class="fas fa-edit"></i></button>' +
                '<button class = "delete"><i class="fas fa-trash"></i></button>';
            figure.appendChild(tools);
        }
        var content = document.getElementById('content');
        content.appendChild(figure);
    }

    function showPosts() {
        var posts = module.getPosts(skip, top, filterConfig);
        for(var i = 0; i < posts.length; ++i) {
            showPost(posts[i]);
        }
        skip += posts.length;
    }

    function clearContent() {
        var content = document.getElementById('content');
        content.innerHTML = '';
        skip = 0;
    }

    function updateFilter() {
        var authors = document.getElementById('filter-authors');
        var tags = document.getElementById('filter-tags');
        var tagsList = [];
        for(var i = 0; i < tags.children.length; ++i) {
            tagsList[i] = tags.children[i].id;
        }
        var authorsList = [];
        for(var i = 0; i < authors.children.length; ++i) {
            authorsList[i] = authors.children[i].id;
        }
        filterConfig.tags = tagsList;
        filterConfig.authors = authorsList;
    }

    function addTag() {
        var tagInput = document.getElementById('tag-input');
        if(tagInput.value !== "" && filterConfig.tags.indexOf(tagInput.value) === -1) {
            var tags = document.getElementById('filter-tags');
            var tag = document.createElement('span');
            tag.innerHTML = '#' + tagInput.value + ' <i class=\"fas fa-minus-circle\"></i>';
            tag.className = 'filter-tag';
            tag.id = tagInput.value;
            tags.appendChild(tag);
            tagInput.value = '';
        }
    }

    function addAuthor() {
        var authorInput = document.getElementById("author-input");
        if(authorInput.value !== "" && filterConfig.authors.indexOf(authorInput.value) === -1) {
            var authors = document.getElementById('filter-authors');
            var author = document.createElement('span');
            author.innerHTML = authorInput.value + ' <i class=\"fas fa-minus-circle\"></i>';
            author.className = 'filter-author';
            author.id = authorInput.value;
            authors.appendChild(author);
            authorInput.value = '';
        }
    }

    function updateLikes(obj) {
        if (userName) {
            var likeList = module.getPost(obj.id).likes;
            if (obj.children[0].classList.contains('active')) {
                obj.children[0].classList.remove('active');
                obj.children[1].innerHTML = Number(obj.children[1].innerHTML) - 1;
                likeList.splice(likeList.indexOf(userName), 1);
            }
            else {
                obj.children[0].classList.add('active');
                obj.children[1].innerHTML = Number(obj.children[1].innerHTML) + 1;
                likeList[likeList.length] = userName;
            }
            module.editPost(obj.id, {likes: likeList});
        }
    }

    function deletePost(obj) {
        var shield = createShield();
        var confirmDialog = document.createElement('div');
        confirmDialog.className = 'confirm-dialog';
        confirmDialog.innerHTML = '<div>Are u sure? U want to delete this post?' +
            '<div class = "tools">' +
            '<button id = "ok">OK</button>' +
            '<button id = "cancel">Cancel</button>' +
            '</div>' +
            '</div>';
        shield.appendChild(confirmDialog);
        var ok = document.getElementById('ok');
        ok.onclick = function () {
            shield.parentNode.removeChild(shield);
            module.removePost(obj.id);
            obj.style.display = 'none';
        };
        var cancel = document.getElementById('cancel');
        cancel.onclick = function () {
            shield.parentNode.removeChild(shield);
        };
    }

    function drawAddForm(shield) {
        shield.innerHTML = '<div class = "new-post">' +
            '<div class="photo">' +
            '<div class="file-upload">\n' +
            '<label>\n' +
            '<input type="file" id="photo" accept=".jpg, .jpeg, .png">\n' +
            '<span>Choose file</span>\n' +
            '</label>\n' +
            '</div>' +
            '<img id="upload-photo" class="postImg"/>' +
            '</div>' +
            '<textarea id="description" maxlength="100">My new photo :)</textarea>' +
            '<input type="text" placeholder="Tags..." id="new-tags"/>' +
            '<div class="tools">' +
            '<button id = "confirm">OK</button>' +
            '<button id= "cancel">Cancel</button>' +
            '</div>\n' +
            '</div>';
    }

    function addPost() {
        var shield = createShield();
        drawAddForm(shield);
        var photo = document.getElementById('photo');
        var img = document.getElementById('upload-photo');
        photo.oninput = function () {
            document.getElementsByClassName('file-upload')[0].style.display = 'none';
            var reader = new FileReader();
            reader.readAsDataURL(photo.files[0]);
            reader.onloadend = function() {
                img.src = reader.result;
                img.alt = description.value;
                img.style.display = 'inline';
            }
        };
        var description = document.getElementById('description');
        description.oninput = function () {
            img.alt = description.value;
        };
        var tags = document.getElementById('new-tags');
        var confirm = document.getElementById('confirm');
        confirm.onclick = function () {
            var post = {};
            if(photo.files[0]) {
                post.photoLink = 'images/' + photo.files[0].name;
            }
            post.createdAt = new Date();
            post.author = userName;
            post.description = description.value;
            post.tags = tags.value.split(' ');
            if(module.addPost(post)) {
                shield.parentNode.removeChild(shield);
                clearContent();
                showPosts();
            }
        };
        var cancel = document.getElementById('cancel');
        cancel.onclick = function () {
            shield.parentNode.removeChild(shield);
        };
    }

    function drawEditForm(shield) {
        shield.innerHTML = '<div class = "new-post">' +
            '<div class="photo">' +
            '<img id="upload-photo" class="postImg"/>' +
            '</div>' +
            '<textarea id="description" maxlength="100"></textarea>' +
            '<input type="text" placeholder="Tags..." id="new-tags"/>' +
            '<div class="tools">' +
            '<button id = "confirm">OK</button>' +
            '<button id= "cancel">Cancel</button>' +
            '</div>\n' +
            '</div>';
    }

    function editPost(obj) {
        var shield = createShield();
        drawEditForm(shield);
        var img = document.getElementById('upload-photo');
        var info = module.getPost(obj.id);
        img.src = info.photoLink;
        img.alt = info.description;
        img.style.display = 'inline';
        var description = document.getElementById('description');
        description.value = info.description;
        description.oninput = function () {
            img.alt = description.value;
        };
        var tags = document.getElementById('new-tags');
        tags.value = '';
        for(var i = 0; i < info.tags.length; ++i) {
            tags.value += info.tags[i] + ' ';
        }
        var confirm = document.getElementById('confirm');
        confirm.onclick = function () {
            var post = {};
            post.photoLink = info.photoLink;
            post.createdAt = info.createdAt;
            post.author = userName;
            post.description = description.value;
            post.tags = tags.value.split(' ');
            if(module.editPost(info.id, post)) {
                shield.parentNode.removeChild(shield);
                clearContent();
                showPosts();
            }
        };
        var cancel = document.getElementById('cancel');
        cancel.onclick = function () {
            shield.parentNode.removeChild(shield);
        };
    }

    function logOut() {
        localStorage.setItem('username', '');
        userName = '';
        showStatus();
        clearContent();
        showPosts();
    }

    function logIn() {
        authorize();
    }

    function authorize() {
        var shield = createShield();
        shield.innerHTML = '<form>\n' +
            '<input type="text" id="username" placeholder="username..."/>\n' +
            '<input type="text" id="password" placeholder="password..."/>\n' +
            '<div class="tools">' +
            '<button id = "confirm">OK</button>' +
            '<button id= "cancel">Cancel</button>' +
            '</div>\n' +
            '</form>';
        var confirm = document.getElementById('confirm');
        confirm.onclick = function () {
            localStorage.setItem('username',document.getElementById('username').value);
        };
        var cancel = document.getElementById('cancel');
        cancel.onclick = function () {
        };
    }

    function createShield() {
        var shield = document.createElement('div');
        shield.className = 'shield';
        document.getElementsByTagName('body')[0].appendChild(shield);
        return shield;
    }

    return {
        posts: showPosts,
        status: showStatus,
        clear: clearContent,
        updateFilter: updateFilter,
        addTag: addTag,
        addAuthor: addAuthor,
        likes: updateLikes,
        delete: deletePost,
        add: addPost,
        edit: editPost,
        logOut: logOut,
        logIn: logIn
    }
}());

controller = function() {
    view.status();
    view.posts();
    var loadMore = document.getElementById('load-more');
    loadMore.onclick = function () {
        view.posts();
    };
    var recent = document.getElementById('recent');
    recent.onclick = function () {
        module.setCompareField('date');
        view.clear();
        view.posts();
    };
    var popular = document.getElementById('popular');
    popular.onclick = function () {
        module.setCompareField('likes');
        view.clear();
        view.posts();
    };
    var addTag = document.getElementById('add-tag-button');
    addTag.onclick = function () {
        view.addTag();
        view.updateFilter();
        view.clear();
        view.posts();
    };
    var addAuthor = document.getElementById('add-author-button');
    addAuthor.onclick = function () {
        view.addAuthor();
        view.updateFilter();
        view.clear();
        view.posts();
    };
    document.body.addEventListener('click', function (event) {
        if(event.target.className === "filter-tag" || event.target.className === "filter-author") {
            event.target.parentNode.removeChild(event.target);
            view.updateFilter();
            view.clear();
            view.posts();
        }
        else if(event.target.parentNode.parentNode.className === "filter-tag" || event.target.parentNode.parentNode.className === "filter-author") {
            event.target.parentNode.parentNode.parentNode.removeChild(event.target.parentNode.parentNode);
            view.updateFilter();
            view.clear();
            view.posts();
        }
        else if(event.target.parentNode.className === 'likes') {
            view.likes(event.target.parentNode);
        }
        else if(event.target.parentNode.parentNode.className === 'likes') {
            view.likes(event.target.parentNode.parentNode);
        }
        else if(event.target.className === 'delete') {
            view.delete(event.target.parentNode.parentNode);
        }
        else if(event.target.id === 'log-out') {
            view.logOut();
        }
        else if(event.target.id === 'log-in') {
            view.logIn();
        }
        else if(event.target.id === 'add-post') {
            view.add();
        }
        else if(event.target.className === 'edit') {
            view.edit(event.target.parentNode.parentNode);
        }
    });
};
document.addEventListener("DOMContentLoaded", controller);