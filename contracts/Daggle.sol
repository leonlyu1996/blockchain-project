pragma solidity ^0.5.0;

contract Daggle {

  struct Competition {
    uint id;
    address problemOwner;
    string title;
    string description;
    uint rewardAmount;
    string trainDataPath;
    string testDataPath;
    mapping (address => Submission) submissions;
    address currentLeader;
    int256 bestAccuracy;
    bool isFinished;
  }

  struct Submission {
    string dataPath;
    int256 accuracy;
    uint timestamp;
  }

  Competition[] public competitions;

  // Constructor
  constructor() public {

  }
  function () external payable {
  }

  function getNumberOfCompetitions() public view returns (uint){
    return competitions.length;
  }

  function createCompetition (
    string memory _title,
    string memory _description,
    uint _rewardAmount,
    string memory _trainDataPath,
    string memory _testDataPath
  ) public payable{

    // assert(_rewardAmount > 0);

    Competition memory newCompetition;
    newCompetition.id = competitions.length;
    newCompetition.problemOwner= msg.sender;
    newCompetition.title = _title;
    newCompetition.description = _description;
    newCompetition.rewardAmount = _rewardAmount;
    newCompetition.trainDataPath = _trainDataPath;
    newCompetition.testDataPath = _testDataPath;
    newCompetition.isFinished = false;

    competitions.push(newCompetition);
  }

  // function getCompetition(uint id) public returns (Competition memory) {
  //   return competitions[id];
  // }

  function submit(uint competitionId, address _competitor, string memory _ipfsPath, int256 _accuracy) public returns (bool) {

    require(competitionId >= 0 && competitionId < competitions.length);

    Competition storage competition = competitions[competitionId];

    require(msg.sender != competition.problemOwner);
    require(competition.isFinished == false);

    competition.submissions[_competitor] = Submission(_ipfsPath, _accuracy, block.timestamp);

    if (_accuracy > competition.bestAccuracy) {
      competition.bestAccuracy = _accuracy;
      competition.currentLeader = _competitor;
    }

    return true;
  }

  function getSubmission(uint competitionId) public view returns (string memory, int256, uint) {
    require(competitionId >= 0 && competitionId < competitions.length);

    Competition storage competition = competitions[competitionId];
    Submission memory mySubmission = competition.submissions[msg.sender];
    return (mySubmission.dataPath, mySubmission.accuracy, mySubmission.timestamp);
  }

  // function evaluate() public returns (Submission) {
  //   //TODO
  // }

  function endCompetition(uint competitionId) public payable returns (string memory, int256, uint) {

      require(competitionId >= 0 && competitionId < competitions.length);

      Competition storage competition = competitions[competitionId];

      require(msg.sender == competition.problemOwner);
      require(msg.value >= competition.rewardAmount);
      require(competition.isFinished == false);

      // cast address to address payable
      address payable winner = address(uint160(competition.currentLeader));

      winner.transfer(competition.rewardAmount);

      competition.isFinished = true;

      Submission memory bestSubmission = competition.submissions[winner];

      return (bestSubmission.dataPath, bestSubmission.accuracy, bestSubmission.timestamp);
    }

}
