const gameLevels = <GameLevel>[
  (
    number: 1,
    winScore: 3,
    canSpawnTall: false,
  ),
  (
    number: 2,
    winScore: 5,
    canSpawnTall: true,
  ),
  (
    number: 3,
    winScore: 7,
    canSpawnTall: false,
  ),
  (
    number: 4,
    winScore: 9,
    canSpawnTall: true,
  ),
  (
    number: 5,
    winScore: 11,
    canSpawnTall: false,
  ),
  (
    number: 6,
    winScore: 13,
    canSpawnTall: true,
  ),
  (
    number: 7,
    winScore: 15,
    canSpawnTall: false,
  ),
  (
    number: 8,
    winScore: 17,
    canSpawnTall: true,
  ),
  (
    number: 9,
    winScore: 19,
    canSpawnTall: false,
  ),
  (
    number: 10,
    winScore: 21,
    canSpawnTall: true,
  ),
];

typedef GameLevel = ({
  int number,
  int winScore,
  bool canSpawnTall,
});
