pragma solidity ^0.8.0;

import "./Company.sol";
import "./Review.sol";

contract FreeBoard {
    address private trustedAddress;

    Company[] public companies;

    mapping(uint256 => Review[]) public reviews;

    // companiesCount and reviewsCount act as ids
    uint256 public companiesCount;
    uint256 public reviewsCount;

    event NewReview(uint256 indexed companyId, uint256 indexed reviewId);
    event NewCompany(uint256 indexed companyId);

    constructor(address _trustedAddress) {
        trustedAddress = _trustedAddress;
    }

    function addReview(
        uint256 companyId,
        uint256 rating,
        string memory reviewCid
    ) public {
        require(companiesCount > 0, "No companies found");
        require(companies[companyId].inserted, "Company not found");

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
        string memory name,
        string memory descriptionCid,
        string memory logoCid
    ) public {
        require(msg.sender == trustedAddress, "Not trusted address");

        Company memory company = Company({
            id: companiesCount,
            name: name,
            descriptionCid: descriptionCid,
            logoCid: logoCid,
            inserted: true
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
