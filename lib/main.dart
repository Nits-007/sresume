import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

void main() {
  runApp(const ShriyaResumeApp());
}

class ShriyaResumeApp extends StatelessWidget {
  const ShriyaResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shriya's Resume 🎀",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF0F5), // Lavender blush
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const KawaiiResumePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KawaiiResumePage extends StatefulWidget {
  const KawaiiResumePage({super.key});

  @override
  State<KawaiiResumePage> createState() => _KawaiiResumePageState();
}

class _KawaiiResumePageState extends State<KawaiiResumePage>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _hasStarted = false;
  late ConfettiController _confettiController;
  late final AnimationController _bgController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Removed _startBgm() due to browser autoplay policies

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _bgController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _startBgm() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('music.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent.shade100,
        elevation: 10,
        icon: _isPlaying
            ? const Icon(Icons.music_note, color: Colors.white)
                .animate(onPlay: (controller) => controller.repeat())
                .shake(duration: 1.seconds)
            : const Icon(Icons.music_off, color: Colors.white),
        label: Text(_isPlaying ? "🎵 BGM On" : "🔈 BGM Off",
            style: GoogleFonts.fredoka(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        onPressed: () {
          setState(() {
            if (_isPlaying) {
              _audioPlayer.pause();
            } else {
              if (!_hasStarted) {
                _startBgm();
                _hasStarted = true;
              } else {
                _audioPlayer.resume();
              }
            }
            _isPlaying = !_isPlaying;
          });
          _confettiController.play();
        },
      ).animate().scale(delay: 500.ms, duration: 500.ms).then().shake(),
      body: Stack(
        children: [
          // Animated Pastel Gradient Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFFFFD1DC), // Pastel Pink
                      Color(0xFFE0BBE4), // Pastel Purple
                      Color(0xFFD291BC), // Soft Magenta
                      Color(0xFFFEC8D8), // Pastel Rose
                    ],
                    stops: [
                      0.0,
                      _bgController.value * 0.5,
                      _bgController.value,
                      1.0
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating Sparkles Background
          Positioned.fill(
            child: const FloatingSparkles(),
          ),

          // Confetti Dropper
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2, // down
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Colors.pink,
                Colors.yellow,
                Colors.lightBlue,
                Colors.purpleAccent
              ],
            ),
          ),

          // MAIN CONTENT
          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // HERO AVATAR
                      ScaleTransition(
                        scale: Tween(begin: 0.95, end: 1.05).animate(
                          CurvedAnimation(
                              parent: _pulseController,
                              curve: Curves.easeInOut),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent.shade100,
                                    Colors.purpleAccent.shade100
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.pink.withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 5)
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/photu.jpg'),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade400,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.orange.withOpacity(0.4),
                                      blurRadius: 10)
                                ],
                              ),
                              child: const Text("✨",
                                  style: TextStyle(fontSize: 30)),
                            )
                                .animate(
                                    onPlay: (controller) => controller.repeat())
                                .shake(duration: 1.seconds, hz: 3)
                                .then()
                                .tint(color: Colors.white, duration: 200.ms),
                          ],
                        ),
                      )
                          .animate()
                          .fade(duration: 800.ms)
                          .scale(begin: const Offset(0.5, 0.5)),

                      const SizedBox(height: 30),

                      // NAME HEADER
                      Text(
                        "Shriya Jaiswal ✨",
                        style: GoogleFonts.fredoka(
                          fontSize: 58,
                          fontWeight: FontWeight.w600,
                          color: Colors.pink.shade500,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 300.ms)
                          .slideY(begin: 0.3, curve: Curves.easeOutBack),

                      const SizedBox(height: 15),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Colors.pink.shade100, width: 3),
                        ),
                        child: Text(
                          "🎀 15 Years Old | Ludo Queen 🌟 | 5'2\" of Pure Chaos 🐾",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: Colors.purple.shade400,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 600.ms)
                          .scale(curve: Curves.elasticOut),

                      const SizedBox(height: 60),

                      // ACADEMICS
                      _buildCuteSectionTitle(
                          "🎓 Adorable Academics", Colors.purple.shade300),
                      const SizedBox(height: 25),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildCuteInfoBadge("B.Tech CSE", "1st Year (25-29)",
                              "💻", Colors.blue.shade100),
                          _buildCuteInfoBadge("ABESIT", "Coolest Kid There",
                              "🏫", Colors.orange.shade100),
                          _buildCuteInfoBadge("Perfect Handwriting",
                              "100/100 Aesthetic", "✏️", Colors.green.shade100),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // SKILLS CAROUSEL
                      _buildCuteSectionTitle(
                          "✨ Super Skills", Colors.pink.shade400),
                      const SizedBox(height: 15),
                      CuteCarousel(
                        height: 280,
                        items: [
                          _buildCuteCarouselCard(
                              "Gol Roti Expert 🫓",
                              "Gordon Ramsay could literally NEVER.",
                              "assets/roti.jpeg",
                              Colors.orange.shade100),
                          _buildCuteCarouselCard(
                              "Elite Binge-Watcher 🍿",
                              "PhD in watching Panchayat & All of Us Are Dead.",
                              "assets/panchayat.jpg",
                              Colors.green.shade100),
                          _buildCuteCarouselCard(
                              "Insta-Juggler 📱",
                              "Managing 10 accounts like a boss.",
                              "assets/insta.jpeg",
                              Colors.purple.shade100),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // ASSETS CAROUSEL
                      _buildCuteSectionTitle(
                          "💎 Mega Rich Assets", Colors.teal.shade300),
                      const SizedBox(height: 15),
                      CuteCarousel(
                        height: 280,
                        items: [
                          _buildCuteCarouselCard(
                              "Very Rich™ 💸",
                              "Stacks on stacks on stacks.",
                              "assets/money.jpeg",
                              Colors.teal.shade100),
                          _buildCuteCarouselCard(
                              "Real Estate Mogul 🏰",
                              "Basically owns monopoly.",
                              "assets/land.jpg",
                              Colors.blue.shade100),
                          _buildCuteCarouselCard(
                              "Army Tanks 🪖",
                              "Private collection. Do not mess.",
                              "assets/tank.jpeg",
                              Colors.red.shade100),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // QUIRKS
                      _buildCuteSectionTitle(
                          "🤡 Silly Quirks", Colors.orange.shade400),
                      const SizedBox(height: 25),
                      _buildCuteQuirkRow(
                          "Chronic Tumblr Buyer 🥤",
                          "Loves buying them, absolutely refuses to actually drink water.",
                          "assets/tumbler.jpeg",
                          Colors.purple.shade50),
                      const SizedBox(height: 20),
                      _buildCuteQuirkRow(
                          "Extremely Clumsy 🤕",
                          "Signature move: Dropping her phone flat on her face while in bed.",
                          "assets/phone.jpg",
                          Colors.pink.shade50),

                      const SizedBox(height: 70),

                      // FOOTER
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 2 * math.pi),
                        duration: const Duration(seconds: 8),
                        builder: (context, double angle, child) {
                          return Transform.rotate(
                            angle: angle,
                            child: const Text("🌸",
                                style: TextStyle(fontSize: 60)),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Hire me? Or let's just go buy another tumbler. 🥺💖",
                        style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.w500,
                          color: Colors.pink.shade400,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true))
                          .moveY(begin: -5, end: 5, duration: 1.seconds),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _confettiController.play();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade300,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 10,
                            shadowColor: Colors.pinkAccent),
                        child: Text("Click for Sparkles! ✨",
                            style: GoogleFonts.nunito(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ).animate().shimmer(duration: 2.seconds, delay: 2.seconds)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuteSectionTitle(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(0.4), width: 3),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: Text(
        title,
        style: GoogleFonts.fredoka(
          fontSize: 32,
          color: color,
        ),
      ),
    )
        .animate()
        .slideX(duration: 600.ms, begin: -0.2, curve: Curves.easeOutBack);
  }

  Widget _buildCuteInfoBadge(
      String title, String subtitle, String emoji, Color bgColor) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
              color: bgColor.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8))
        ],
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 45))
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 800.ms),
          const SizedBox(height: 15),
          Text(title,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.black87),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle,
              style: GoogleFonts.nunito(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ),
    ).animate().scale(curve: Curves.elasticOut, duration: 1.seconds);
  }

  Widget _buildCuteCarouselCard(
      String title, String desc, String imgUrl, Color bgColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
                color: bgColor.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10))
          ],
          border: Border.all(color: Colors.white, width: 5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imgUrl,
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.2),
                colorBlendMode: BlendMode.lighten),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: bgColor, width: 2),
                        ),
                        child: Text(title,
                            style: GoogleFonts.fredoka(
                                fontSize: 24, color: Colors.blueGrey.shade800),
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(desc,
                            style: GoogleFonts.nunito(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCuteQuirkRow(
      String title, String desc, String imgUrl, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: [
            BoxShadow(
                color: bgColor.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ]),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(imgUrl,
                  width: 110, height: 110, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.fredoka(
                        fontSize: 24, color: Colors.black87)),
                const SizedBox(height: 8),
                Text(desc,
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          )
        ],
      ),
    ).animate().slideX(begin: 0.2, curve: Curves.easeOutQuad);
  }
}

class CuteCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;

  const CuteCarousel({super.key, required this.items, required this.height});

  @override
  State<CuteCarousel> createState() => _CuteCarouselState();
}

class _CuteCarouselState extends State<CuteCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.25)).clamp(0.0, 1.0);
              } else {
                value = index == 0 ? 1.0 : 0.75;
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeOutBack.transform(value) * widget.height,
                  width: Curves.easeOutBack.transform(value) * 400,
                  child: child,
                ),
              );
            },
            child: widget.items[index],
          );
        },
      ),
    );
  }
}

// Sparkles background
class FloatingSparkles extends StatefulWidget {
  const FloatingSparkles({super.key});

  @override
  State<FloatingSparkles> createState() => _FloatingSparklesState();
}

class _FloatingSparklesState extends State<FloatingSparkles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Sparkle> _sparkles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      _sparkles.add(Sparkle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 20 + 10,
        speed: _random.nextDouble() * 0.5 + 0.1,
        angle: _random.nextDouble() * math.pi * 2,
        icon: _random.nextBool() ? Icons.favorite : Icons.star,
        color:
            _random.nextBool() ? Colors.pink.shade100 : Colors.yellow.shade100,
      ));
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SparklePainter(_sparkles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Sparkle {
  double x;
  double y;
  double size;
  double speed;
  double angle;
  IconData icon;
  Color color;

  Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
    required this.icon,
    required this.color,
  });
}

class SparklePainter extends CustomPainter {
  final List<Sparkle> sparkles;
  final double progress;

  SparklePainter(this.sparkles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var sparkle in sparkles) {
      double currentY = sparkle.y - (progress * sparkle.speed);
      if (currentY < -0.1) currentY += 1.2; // loop back to bottom

      double currentX =
          sparkle.x + (math.sin(progress * math.pi * 2 + sparkle.angle) * 0.05);

      textPainter.text = TextSpan(
        text: String.fromCharCode(sparkle.icon.codePoint),
        style: TextStyle(
          fontSize: sparkle.size,
          fontFamily: sparkle.icon.fontFamily,
          color: sparkle.color.withOpacity(0.6),
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(currentX * size.width, currentY * size.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
