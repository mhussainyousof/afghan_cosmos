import 'package:afghan_cosmos/provider/them_mode.dart';
import 'package:afghan_cosmos/screens/chat/chat_screen.dart';
import 'package:afghan_cosmos/screens/menu/menu_data.dart';
import 'package:afghan_cosmos/utils/theme/colors.dart';
import 'package:afghan_cosmos/widgets/animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: TColors.primary,
        // child: Icon(FontAwesomeIcons.headset),
        child: Icon(Icons.support_agent, size: 35, color: Colors.white,),

        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(

                initialChildSize: 0.95,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                expand: false,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade900.withOpacity(0.70)
                              : Colors.white.withOpacity(0.85),
                      border: Border.all(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white24
                                : Colors.black26,
                      ),
                    
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: TColors.grey,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Expanded(child: ChatScreen(scrollController: controller)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text('AFGHAN COSMOS'),
        actions: [
          Row(
            children: [
              Icon(Iconsax.location, size: 20),
              SizedBox(width: 4),
              Text('Qala-e-Fatullah', style: TextStyle(color: Colors.white)),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/icons/logo.png'),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        ref.watch(themeModeProvider) == ThemeMode.light
                            ? Iconsax.moon
                            : Iconsax.sun_15,
                      ),
                      onPressed: () {
                        final current = ref.read(themeModeProvider);
                        ref.read(themeModeProvider.notifier).state =
                            current == ThemeMode.light
                                ? ThemeMode.dark
                                : ThemeMode.light;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ...buildMenuItems(menuItems),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Badge
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Welcome to Afghan Cosmos',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Title
              Text(
                'Your Trusted Partner in',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              
               FancyAnimatedText(),
               
              
              SizedBox(height: 20),
        
              Center(child: Image.asset('assets/icons/logo.png', height: 200)),
            ],
          ),
        ),
      ),
    );
  }
}
