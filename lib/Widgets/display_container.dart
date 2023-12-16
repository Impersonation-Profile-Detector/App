import 'package:flutter/material.dart';

class DisplayContainer extends StatefulWidget {
  final dynamic user;
  const DisplayContainer({super.key, this.user});

  @override
  State<DisplayContainer> createState() => _DisplayContainerState();
}

class _DisplayContainerState extends State<DisplayContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.user['profile_pic_url'] ?? '',
                    height: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16),
                  child: Text(
                    widget.user['full_name'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    )),
              ],
            ),
          )),
    );
  }
}
