import 'package:flutter/material.dart';

class ActivityRankingItem extends StatelessWidget {
  const ActivityRankingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                      backgroundImage:Image.asset('assets/images/logo.png').image
                       
                    ),             
                ),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Activity name'),
                      // Text('13 new activity')
                    ],
                  ),
                ),
                
                const Text('131 people participated')
              ],
            ),
          )),
    );
  }
}
