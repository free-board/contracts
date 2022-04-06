pragma solidity ^0.8.0;

import "./Company.sol";
import "./Review.sol";

contract FreeBoard {
    address payable public ownerAddress;

    Company[] public companies;

    mapping(uint256 => Review[]) public reviews;

    // companiesCount and reviewsCount act as ids
    uint256 public companiesCount;
    uint256 public reviewsCount;

    event NewReview(uint256 indexed companyId, uint256 indexed reviewId);
    event NewCompany(uint256 indexed companyId);

    constructor(address _ownerAddress) {
        ownerAddress = payable(_ownerAddress);
    }

    function withdraw() public {
        ownerAddress.transfer(address(this).balance);
    }

    function addReview(
        uint256 companyId,
        uint256 rating,
        bytes32 reviewCid
    ) public {
        require(companiesCount > 0, "No companies found");
        require(companiesCount >= companyId, "Company not found");

        Review memory review = Review({
            id: reviewsCount,
            from: msg.sender,
            rating: rating,
            reviewCid: reviewCid
        });

        reviews[companyId].push(review);
        emit NewReview(companyId, reviewsCount);
        reviewsCount++;
    }

    function addCompany(
        bytes32 name,
        bytes32 descriptionCid,
        bytes32 logoCid
    ) public payable {
        require(msg.value == 0.03 ether, "Provide 0.03 ETH");

        Company memory company = Company({
            id: companiesCount,
            name: name,
            descriptionCid: descriptionCid,
            logoCid: logoCid
        });

        companies.push(company);
        emit NewCompany(companiesCount);
        companiesCount++;
    }

    function getReviews(uint256 companyId)
        public
        view
        returns (Review[] memory)
    {
        return reviews[companyId];
    }

    function getReview(uint256 companyId, uint256 reviewId)
        public
        view
        returns (Review memory)
    {
        return reviews[companyId][reviewId];
    }

    function getCompanies() public view returns (Company[] memory) {
        return companies;
    }

    function getCompany(uint256 companyId)
        public
        view
        returns (Company memory)
    {
        return companies[companyId];
    }
}
