// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "./libraries/Base64.sol";

contract EpicNfts is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("EpicNfts", "EPI") {}

    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    //adjectives
    string[] firstWords = [
        "Epic",
        "Charming",
        "Cruel",
        "Gentle",
        "Sexy",
        "Huge",
        "Perfect",
        "Delicious",
        "Spooky",
        "Cute",
        "Tasty",
        "Silly",
        "Lame",
        "Annoying",
        "Terrible"
    ];
    //fruits
    string[] secondWords = [
        "Watermelon",
        "Cherry",
        "Custardapple",
        "Grape",
        "Mango",
        "Orange",
        "Banana",
        "Strawberry",
        "Pear",
        "Muskmelon",
        "Papaya",
        "Apple",
        "Kiwi",
        "Blueberry",
        "Fig"
    ];
    //collections
    string[] thirdWords = [
        "Collection",
        "Apolocalypse",
        "Disaster",
        "Attack",
        "Gift",
        "Surprise",
        "Display",
        "Brunch",
        "Show",
        "Waste",
        "Situation",
        "Way",
        "Chain"
    ];

    string[] colors = [
        "red",
        "#08C2A8",
        "black",
        "yellow",
        "blue",
        "green",
        "pink",
        "purple",
        "orange",
        "brown",
        "gray"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    function pickRandomFirstWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = random(
            string(
                abi.encodePacked("FIRST_EPIC_WORD", Strings.toString(tokenId))
            )
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomSecondWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = random(
            string(
                abi.encodePacked("SECOND_EPIC_WORD", Strings.toString(tokenId))
            )
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = random(
            string(
                abi.encodePacked("THIRD_EPIC_WORD", Strings.toString(tokenId))
            )
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = random(
            string(abi.encodePacked("EPIC_COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory randomColor = pickRandomColor(newItemId);
        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A collection of epic nfts.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenURI);

        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}