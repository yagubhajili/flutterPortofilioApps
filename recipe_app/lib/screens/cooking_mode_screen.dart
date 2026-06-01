import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meal.dart';

class CookingModeScreen extends StatefulWidget {
  final Meal meal;

  const CookingModeScreen({
    super.key,
    required this.meal,
  });

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  final PageController _pageController = PageController();
  List<String> _steps = [];
  int _currentStepIndex = 0;

  // Timer variables
  int _timerSeconds = 300; // Default 5 minutes
  int _timerRemaining = 300;
  bool _isTimerRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _parseSteps();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _parseSteps() {
    final instructions = widget.meal.strInstructions ?? '';
    if (instructions.isEmpty) {
      _steps = ['Hazırlanma qaydası qeyd edilməyib.'];
      return;
    }

    // Split instructions by period, carriage return or newlines
    final raw = instructions.split(RegExp(r'\.+(?:\s|$)|\r\n|\n'));
    List<String> parsed = [];
    for (var sentence in raw) {
      final clean = sentence.trim();
      // Remove step numbers (e.g. "1.", "Step 2:") if parsed
      final withoutStepNum = clean.replaceAll(RegExp(r'^(?:[Ss]tep\s+)?\d+[\.:\s]*'), '').trim();
      if (withoutStepNum.isNotEmpty && withoutStepNum.length > 5) {
        parsed.add(withoutStepNum);
      }
    }

    if (parsed.isEmpty) {
      parsed = [instructions];
    }

    setState(() {
      _steps = parsed;
    });
  }

  // Timer logic
  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _isTimerRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerRemaining > 0) {
          setState(() {
            _timerRemaining--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isTimerRunning = false;
          });
          _showTimerFinishedAlert();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timerRemaining = _timerSeconds;
      _isTimerRunning = false;
    });
  }

  void _adjustTimer(int seconds) {
    setState(() {
      _timerSeconds = (_timerSeconds + seconds).clamp(10, 3600); // Between 10s and 1hr
      _timerRemaining = _timerSeconds;
    });
  }

  void _showTimerFinishedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1915),
        title: Row(
          children: const [
            Icon(Icons.alarm_on, color: Color(0xFFFF7E21)),
            SizedBox(width: 10),
            Text(
              'Taymer Bitdi! 🔔',
              style: TextStyle(color: Colors.white, fontFamily: 'Outfit'),
            ),
          ],
        ),
        content: const Text(
          'Mərhələ üçün təyin edilmiş vaxt tamamlandı. Yeməyi yoxlamağı unutmayın!',
          style: TextStyle(color: Color(0xFFA09890)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam', style: TextStyle(color: Color(0xFFFF7E21))),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120E0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF120E0B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.meal.strMeal,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7F4F2),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mərhələ ${_currentStepIndex + 1} / ${_steps.length + 1}', // +1 for the success page
                        style: const TextStyle(color: Color(0xFFA09890), fontSize: 13),
                      ),
                      Text(
                        '${((_currentStepIndex + 1) / (_steps.length + 1) * 100).toInt()}% tamamlandı',
                        style: const TextStyle(color: Color(0xFFFF7E21), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentStepIndex + 1) / (_steps.length + 1),
                      backgroundColor: const Color(0xFF1F1915),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF7E21)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Main steps slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStepIndex = index;
                  });
                },
                itemCount: _steps.length + 1, // +1 for completion splash screen
                itemBuilder: (context, index) {
                  if (index == _steps.length) {
                    // Celebration Screen
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7E21).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.restaurant_menu,
                              color: Color(0xFFFF7E21),
                              size: 100,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Süfrəniz Nuş Olsun! 🎉',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Yeməyiniz artıq hazırdır. Tələbə dostlarınızla birlikdə dadına baxın!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFA09890),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 36),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7E21),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                            child: const Text('Təlimatı Bitir', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }

                  // Standard step layout
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7E21).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'MƏRHƏLƏ ${index + 1}',
                                style: const TextStyle(
                                  color: Color(0xFFFF7E21),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _steps[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cooking Timer Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1915),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2C241E)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Color(0xFFFF7E21), size: 30),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dəqiqə Ölçən (Timer)',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _adjustTimer(-60),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C241E),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove, color: Colors.white, size: 14),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(_timerRemaining),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _adjustTimer(60),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C241E),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Timer controls
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_isTimerRunning ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 38),
                        color: const Color(0xFFFF7E21),
                        onPressed: _toggleTimer,
                      ),
                      IconButton(
                        icon: const Icon(Icons.replay, size: 24),
                        color: const Color(0xFFA09890),
                        onPressed: _resetTimer,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Next / Prev control buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStepIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFA09890),
                          side: const BorderSide(color: Color(0xFF2C241E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Əvvəlki'),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 16),
                  if (_currentStepIndex < _steps.length)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7E21),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Növbəti', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  else
                    const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
