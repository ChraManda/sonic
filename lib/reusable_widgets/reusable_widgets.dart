
import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
  );
}

Widget resusableTextField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    ) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0), // Add bottom spacing here
    child: Container(
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: Colors.black26,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Color(0xFF4F4F4F)),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black54,
          ),
          labelText: text,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color(0xFFECECEC),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10, // **Increases vertical space for centering**
            horizontal: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Color(0xFFDADADA),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Color(0xFFBDBDBD),
              width: 2.0,
            ),
          ),
        ),
        keyboardType: isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
      ),
    ),
  );
}




Container signInSignUpButton(
    BuildContext context,
    bool isLogin,
    Function onTap,
    ) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
    // Place 'child:' last in this Container constructor
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.limeAccent;
          }
          return Colors.lime;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      // 'child:' is also last in the ElevatedButton constructor
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLogin ? 'Log In' : 'Sign Up',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.black87, size: 24,),
        ],
      ),
    ),
  );
}
Widget buildLabel(String labelText) {
  return Text(
    labelText,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );
}


//=================================
//======== Custom Button =========
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.color = Colors.lime, // Default color
    this.icon,
  }) : super(key: key);

  static const double _buttonWidth = 350;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _buttonWidth,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return color.withValues(alpha: 0.8);
            }
            return color;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: icon == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            // If icon is null, only show the label centered
            if (icon == null)
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            else ...[
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: Colors.white70, size: 24),
            ]
          ],
        ),
      ),
    );
  }
}




//   ********* Custom  Label **********
Widget CustomLabel({
  required String text,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  Alignment alignment = Alignment.center,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return Align(
    alignment: alignment,
    child: Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    ),
  );
}



// ****************** SEcondary Button ******************
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color borderColor;
  final IconData icon;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.borderColor = Colors.white, // Default outline color
    this.icon = Icons.chevron_right,
  }) : super(key: key);

  static const double _buttonWidth = 350;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _buttonWidth,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor, width: 1), // Outline stroke
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, color: borderColor, size: 24),
          ],
        ),
      ),
    );
  }
}



//*********** Back Button ****************
class RoundedBackButton extends StatelessWidget {
  final String? route;

  const RoundedBackButton({super.key, this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Navigator.pushReplacementNamed(context, route!);
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: const Icon(Icons.arrow_back, color: Colors.blue),
        ),
      ),
    );
  }
}


Widget popButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
    child: GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: const Icon(Icons.arrow_back, color: Colors.blue),
      ),
    ),
  );
}


Widget popLabel(BuildContext context, {required String label}) {
  return TextButton(
    onPressed: () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    },
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
