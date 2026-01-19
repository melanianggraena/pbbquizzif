import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isGlobal = true;

  final List<Map<String, dynamic>> leaderboardData = [
    {
      'rank': 1,
      'name': 'Ethan',
      'points': '26,839',
      'image': 'https://i.pravatar.cc/150?img=33'
    },
    {
      'rank': 2,
      'name': 'Jackson',
      'points': '24,237',
      'image': 'https://i.pravatar.cc/150?img=13'
    },
    {
      'rank': 3,
      'name': 'Emma-Aria',
      'points': '19,786',
      'image': 'https://i.pravatar.cc/150?img=45'
    },
    {
      'rank': 4,
      'name': 'Marsha Fisher',
      'points': '16 pts',
      'image': 'https://i.pravatar.cc/150?img=20'
    },
    {
      'rank': 5,
      'name': 'Juanita Canner',
      'points': '15 pts',
      'image': 'https://i.pravatar.cc/150?img=27'
    },
    {
      'rank': 6,
      'name': 'You',
      'points': '14 pts',
      'image': 'https://i.pravatar.cc/150?img=12',
      'isCurrentUser': true
    },
    {
      'rank': 7,
      'name': 'Tamara Schmidt',
      'points': '13 pts',
      'image': 'https://i.pravatar.cc/150?img=41'
    },
    {
      'rank': 8,
      'name': 'Ricardo Veum',
      'points': '12 pts',
      'image': 'https://i.pravatar.cc/150?img=56'
    },
    {
      'rank': 9,
      'name': 'Gary Sanford',
      'points': '11 pts',
      'image': 'https://i.pravatar.cc/150?img=68'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E40AF),
            Color(0xFF3B82F6),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quiz Leaderboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                            SizedBox(width: 4),
                            Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.card_giftcard, color: Colors.white),
                      const SizedBox(width: 8),
                      const Icon(Icons.notifications_outlined, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isGlobal = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isGlobal ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Global',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isGlobal ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isGlobal = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isGlobal ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'National',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !isGlobal ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Top 3
            SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTopRanker(2, 'Jackson', '24,237', 'https://i.pravatar.cc/150?img=13', 140),
                  const SizedBox(width: 8),
                  _buildTopRanker(1, 'Ethan', '26,839', 'https://i.pravatar.cc/150?img=33', 180),
                  const SizedBox(width: 8),
                  _buildTopRanker(3, 'Emma-Aria', '19,786', 'https://i.pravatar.cc/150?img=45', 140),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Leaderboard List
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: leaderboardData.length - 3,
                  itemBuilder: (context, index) {
                    final data = leaderboardData[index + 3];
                    final isCurrentUser = data['isCurrentUser'] ?? false;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.blue.shade50 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: isCurrentUser ? Border.all(color: Colors.blue, width: 2) : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${data['rank']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(data['image']),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              data['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            data['points'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRanker(int rank, String name, String points, String image, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (rank == 1) const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(image),
            ),
            if (rank <= 3)
              Positioned(
                bottom: -5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: rank == 1
                        ? Colors.amber
                        : rank == 2
                            ? Colors.grey.shade400
                            : Colors.brown.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          points,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: rank == 1
                  ? [Colors.amber.shade300, Colors.amber.shade600]
                  : rank == 2
                      ? [Colors.grey.shade300, Colors.grey.shade500]
                      : [Colors.brown.shade300, Colors.brown.shade500],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}