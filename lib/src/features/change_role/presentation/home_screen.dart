import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: const Text('Homepage', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined)),
        ],
      ),
      body: const VolunteerHomepage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class VolunteerHomepage extends StatelessWidget {
  const VolunteerHomepage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                'Welcome Volunteer Name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                  child: Container(
                height: 90,
                width: 150,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activities',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '30',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '+5 this month',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.green),
                      ),
                    ]),
              )),
              Card(
                  child: Container(
                height: 90,
                width: 150,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hours contribute',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '120',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '24h this month',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.green),
                      ),
                    ]),
              )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Activities',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.lightBlue),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              height: 300.0,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) =>
                    const ActivityCard(),
              )),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activities you may interest',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.lightBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          SizedBox(
            height: 300.0,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) =>
                const ActivityCard(),
            )
          ),
        ],
      ),
    );
  }
}

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
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
                    const SizedBox(height: 5,),
                    Text(
                      'The helpers',
                      style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.blue),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Ward 14, District 10, Ho Chi Minh',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: Text(
                        'dfasdfas asdfaseasdfaweeeeee eeasvsdfasfasdf',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Here put the stack')
                        ),
                        Expanded(
                          child: Text('5/20 slots')
                        ),
                      ],
                    )
                  ],
                )
              ),
            )
          ],
        )
      ),
    );
  }
}
