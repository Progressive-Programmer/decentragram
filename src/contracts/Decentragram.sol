pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "Decentragram";


    // Storage 
    uint public imageCount = 0;
    mapping(uint=> Image) public images;

    struct Image {
        uint id;
        string hash;
        string description;
        uint tipAmount;
        address payable author;
    }

    event ImageCreated (
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
    );

    event ImageTipped (
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
    );

    // create image 
    function uploadImage(string memory _imgHash, string memory _description) public {
        require(bytes(_imgHash).length > 0);
        require(bytes(_description).length > 0, 'Add Image');
        require(msg.sender != address(0x0));

        // image count 
        imageCount ++;

        images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender );

        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender );
    }

    function tipImageOwner(uint _id) public payable{
        require(_id>0 && _id <= imageCount);
        //  Fetch the image 
        Image memory _image = image[_id];
        //  fetch the author
        address payable _author = _image.author;
        // pay the author
        address(_author).transfer(msg.value);
        //  increment the tip amount 
        _image.tipAmount = _image.tipAmount + msg.value ;
        // update the image 
        images[_id] = _image;
        //  trigger an event 
        emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
    }

}