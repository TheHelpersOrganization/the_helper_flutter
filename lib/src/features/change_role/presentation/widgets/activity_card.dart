import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 200,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 200,
                color: Colors.amber,
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity Name',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'The helpers',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.blue),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Ward 14, District 10, Ho Chi Minh',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Text(
                            'dfasdfas asdfaseasdfaweeeeee eeasvsdfasfasdf',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const[
                            Expanded(child: Text('Here put the stack')),
                            Expanded(child: Text('5/20 slots')),
                          ],
                        )
                      ],
                    )),
              )
            ],
          )),
    );
  }
}