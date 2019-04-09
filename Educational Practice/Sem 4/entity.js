const fs = require('fs');
const path = require('path');

const entity =  (function () {

    var id = '0000';

    var schema = {
        description: 'String',
        createdAt: 'Date',
        author: 'String',
        photoLink: 'String'
    };

    function validatePost(object){
        for(var item in schema){
            if(!object.hasOwnProperty(item)){
                return false;
            }
            if(object[item].constructor.name !== schema[item]){
                return false;
            }
        }
        return true;
    }

    function compareToDate(a, b){
        return a.createdAt < b.createdAt;
    }

    function compareToLikes(a, b){
        return a.likes.length < b.likes.length;
    }

    function addPost(post) {
        if(validatePost(post)){
            post.id = id = (parseInt(id) + 1).stringify();
            post.likes = [];
            post.status = 'public';
            var posts;
            fs.readFile(path.join(__dirname, 'server/data/posts.json'), function (err, data) {
                if (err) {
                    throw err;
                }
                posts = JSON.parse(data);
                posts.push(post);
            });
            fs.writeFile(path.join(__dirname, 'server/data/posts.json'), JSON.stringify(posts));
            return true;
        }
        return false;
    }

    function editPost(postID, object) {
        var posts, post;
        fs.readFile(path.join(__dirname, 'server/data/posts.json'), function (err, data) {
            if (err) {
                throw err;
            }
            posts = JSON.parse(data);
            post =  posts.find(function (x) { return x.id === postID; });
            if(post != null && validatePost(object)){
                Object.assign(post, object);
                fs.writeFile(path.join(__dirname, 'server/data/posts.json'), JSON.stringify(posts));
                return true;
            }
            return false;
        });
    }

    function getPosts(skip, top, filterConfig) {
        fs.readFile(path.join(__dirname, 'server/data/posts.json'), function (err, data) {
            if(err) {
                throw err;
            }
            var posts = JSON.parse(data);
            for(var i = 0; i < posts.length; ++i) {
                if(posts[i].status !== 'deleted') {
                    posts[posts.length] = posts[i];
                }
            }
            if(filterConfig.tags) {
                posts = posts.filter(function (x) {
                    for(var i = 0 ; i < filterConfig.tags.length; ++i) {
                        if(x.tags.indexOf(filterConfig.tags[i]) === -1) {
                            return false;
                        }
                    }
                    return true;
                });
            }
            if(filterConfig.authors) {
                posts = posts.filter(function (x) {
                    if(filterConfig.authors.length === 0) {
                        return true;
                    }
                    for(var i = 0; i < filterConfig.authors.length; ++i) {
                        if(x.author === filterConfig.authors[i]) {
                            return true;
                        }
                    }
                    return false;
                });
            }
            if(filterConfig.compareField === 'date') {
                posts.sort(compareToDate);
            }
            if(filterConfig.compareField === 'likes') {
                posts.sort(compareToLikes);
            }
            return posts.slice(skip, skip + top);
        });
    }

    function getPost(postID){
        fs.readFile(path.join(__dirname, 'server/data/posts.json'), function (err, data) {
            if (err) {
                return null;
            }
            var posts = JSON.parse(data);
            return posts.find(function (x) { return x.id === postID; });
        });
    }

    function removePost(postID) {
        fs.readFile(path.join(__dirname, 'server/data/posts.json'), function (err, data) {
            if (err) {
                throw err;
            }
            var posts = JSON.parse(data);
            for (var i = 0; i < posts.length; ++i) {
                if(posts[i].id === postID){
                    posts[i].status = 'deleted';
                    return true;
                }

            }
            return false;
        });
    }

    return {
        getPosts: getPosts,
        getPost: getPost,
        validatePost: validatePost,
        addPost: addPost,
        editPost: editPost,
        removePost: removePost
    }
}());

module.exports = entity;