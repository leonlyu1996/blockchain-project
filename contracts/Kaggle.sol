pragma solidity ^0.5.0;

contract Kaggle {

  struct Submission {
    address paymentAddress;
    address resultAddress;
    uint score;
    unit rank;
    uint date;
  }

  address public organizer;
  uint public bestSubmissionIndex;
  int256 public bestSubmissionAccuracy = 0;
  int256 public modelAccuracyCriteria;

  address trainDataAddress;
  address testDataAddress;

  mapping(address => Submission) submission_queue;

  // Constructor
  constructor() public {
    //TODO
  }

  function submit(...) public returns (uint) {
    //TODO
  }

  function getSubmissions() public returns (Submission[]) {
    return submission_queue;
  }

  function getSubmission() public returns (Submission) {
    return submission_queue[msg.sender];
  }

  function evaluate() public returns (Submission) {
    //TODO
  }

}