import 'package:flutter/material.dart';
import 'package:torva/models/treasure_model.dart';

class TreasureCard extends StatefulWidget {
  final Treasure treasure;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onNavigatePressed;

  const TreasureCard({
    super.key,
    required this.treasure,
    this.isFavorite = false,
    required this.onFavoritePressed,
    required this.onNavigatePressed,
  });

  @override
  State<TreasureCard> createState() => _TreasureCardState();
}

class _TreasureCardState extends State<TreasureCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(TreasureCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            // Treasure Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  widget.treasure.photoUrls.isNotEmpty
                      ? Image.network(
                        widget.treasure.photoUrls.first,
                        width: 70,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'assets/TrovaLogo.png',
                        width: 70,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
            ),
            const SizedBox(width: 16),

            // Treasure Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.treasure.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color:
                              _isFavorite
                                  ? const Color(0xFF7033FA)
                                  : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          widget.onFavoritePressed();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "#${widget.treasure.id.substring(0, 6).toUpperCase()}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 8),

                  // Difficulty and Distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Difficulty indicators
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.local_fire_department,
                            size: 20,
                            color:
                                index < widget.treasure.difficultyLevel
                                    ? const Color(0xFF7033FA)
                                    : Colors.grey.shade300,
                          );
                        }),
                      ),

                      // Distance
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '200m Away',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      // Navigate button
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7033FA),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.navigation_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: widget.onNavigatePressed,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
