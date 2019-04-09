var module = (function () {
    var posts = [
        {
            id: '0001',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-24T23:00:00'),
            author: 'notJoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0002',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-18T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0003',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-05T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0004',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-04T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0005',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0006',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-07T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0007',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-08-28T23:00:00'),
            author: 'notJoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0008',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'notJoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0009',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0010',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0011',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'notJoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0012',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0013',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0014',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0015',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0016',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0017',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-01-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0018',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy', 'batsila'],
            status: 'public'
        },
        {
            id: '0019',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        },
        {
            id: '0020',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, nunc nec aliquet.',
            createdAt: new Date('2018-02-23T23:00:00'),
            author: 'JoyNy',
            photoLink: 'images/testpicture.jpg',
            tags: ['tag', 'sometag'],
            likes: ['JoyNy', 'notJoyNy'],
            status: 'public'
        }
    ];
    var id = '21';

    var schema = {
        description: 'String',
        createdAt: 'Date',
        author: 'String',
        photoLink: 'String'
    };

    var compareField = 'date';

    function compareToDate(a, b){
        return a.createdAt < b.createdAt;
    }

    function compareToLikes(a, b){
        return a.likes.length < b.likes.length;
    }

    function compareTo(a, b) {
        if(compareField === 'date') {
            return compareToDate(a, b);
        }
        else {
            return compareToLikes(a, b);
        }
    }

    function setCompareField(param) {
        compareField = param;
    }

    function getPost(postID){
        return posts.find(function (x) { return x.id === postID; });
    }

    function removePost(postID) {
        for (var i = 0; i < posts.length; ++i) {
            if(posts[i].id === postID){
                posts[i].status = 'deleted';
                return true;
            }
        }
        return false;
    }

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

    function addPost(post) {
        if(validatePost(post)){
            post.id = id + 1;
            post.likes = [];
            post.status = 'public';
            posts.push(post);
            return true;
        }
        return false;
    }

    function editPost(postID, object) {
        var post = getPost(postID);
        if(post != null && validatePost(object)){
            Object.assign(post, object);
            return true;
        }
        return false;
    }

    function getPosts(skip, top, filterConfig) {
        var toShow = [];
        for(var i = 0; i < posts.length; ++i) {
            if(posts[i].status !== 'deleted') {
                toShow[toShow.length] = posts[i];
            }
        }
        if(filterConfig.createdAt){
            toShow = toShow.filter(function (x) {
                return (x.createdAt.getTime() === filterConfig.createdAt.getTime() &&
                    x.createdAt.getDate() === filterConfig.createdAt.getDate()); });
        }
        if(filterConfig.tags) {
            toShow = toShow.filter(function (x) {
                for(var i = 0 ; i < filterConfig.tags.length; ++i) {
                    if(x.tags.indexOf(filterConfig.tags[i]) === -1) {
                        return false;
                    }
                }
                return true;
            });
        }
        if(filterConfig.authors) {
            toShow = toShow.filter(function (x) {
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
        toShow.sort(compareTo);
        return toShow.slice(skip, skip + top);
    }

    return {
        getPosts: getPosts,
        getPost: getPost,
        validatePost: validatePost,
        addPost: addPost,
        editPost: editPost,
        removePost: removePost,
        setCompareField: setCompareField
    }
}());