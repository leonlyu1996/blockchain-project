pragma solidity ^0.5.0;

contract Daggle {

  struct Submission {
    string ipfsPath;
    int256 accuracy;
    uint timestamp;
  }

  address public problemOwner;
  string public title;
  string public description;
  uint public rewardAmount;
  bool public isFinished;
  string trainDataIpfsPath;
  string testDataIpfsPath;

  address public currentLeader;
  int256 public bestAccuracy;

  mapping (address => Submission) submissions;

  // Constructor
  constructor() public {
  }

  function createCompetition(
    string memory _title, 
    string memory _description, 
    uint _rewardAmount, 
    string memory _trainDataIpfsPath, 
    string memory _testDataIpfsPath
  ) public payable {
    assert(_rewardAmount > 0);
    require(msg.value >= rewardAmount);

    problemOwner = msg.sender;
    title = _title;
    description = _description;
    rewardAmount = _rewardAmount;
    trainDataIpfsPath = _trainDataIpfsPath;
    testDataIpfsPath = _testDataIpfsPath;
    bestAccuracy = 0;
    isFinished = false;
  }

  function submit(address _competitor, string memory _ipfsPath, int256 _accuracy) public returns (bool) {
    assert(isFinished == false);

    require(msg.sender != problemOwner);

    submissions[_competitor] = Submission(_ipfsPath, _accuracy, block.timestamp);

    if (_accuracy > bestAccuracy) {
      bestAccuracy = _accuracy;
      currentLeader = _competitor;
    }

    return true;

  }

  function getSubmission() public view returns (string memory, int256, uint) {
    Submission memory mySubmission = submissions[msg.sender];
    return (mySubmission.ipfsPath, mySubmission.accuracy, mySubmission.timestamp);
  }

  // function evaluate() public returns (Submission) {
  //   //TODO
  // }

  function finalize() public returns (string memory, int256, uint) {
      // Make sure contract is not terminated
      assert(isFinished == false);

      require(msg.sender == problemOwner);
      
      // cast address to address payable
      address payable winner = address(uint160(currentLeader));

      winner.transfer(address(this).balance);
      
      isFinished = true;

      Submission memory bestSubmission = submissions[winner];

      return (bestSubmission.ipfsPath, bestSubmission.accuracy, bestSubmission.timestamp);
    }

}