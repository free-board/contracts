pragma solidity ^0.8.0;

import "./Company.sol";
import "./Review.sol";

contract Jobz {
    address private trustedAddress;
    Company[] public companies;
    mapping(uint256 => Review[]) public reviews;

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
        require(companies.length > 0, "No companies found");
        require(companies[companyId].inserted, "Company not found");
        uint256 reviewId = reviews[companyId].length;

        Review memory review = Review({
            id: reviewId,
            from: msg.sender,
            rating: rating,
            reviewCid: reviewCid
        });

        reviews[companyId].push(review);
        emit NewReview(companyId, reviewId);
    }

    function addCompany(
        string memory name,
        string memory descriptionCid,
        string memory logoCid
    ) public {
        require(msg.sender == trustedAddress, "Not trusted address");
        uint256 companyId = companies.length;

        Company memory company = Company({
            id: companyId,
            name: name,
            descriptionCid: descriptionCid,
            logoCid: logoCid,
            inserted: true
        });

        companies.push(company);
        emit NewCompany(companyId);
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
