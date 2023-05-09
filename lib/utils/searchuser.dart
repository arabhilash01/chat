import 'package:chatapplication/firebase/auth_helper.dart';
import 'package:chatapplication/firebase/chat_helper.dart';
import 'package:chatapplication/screens/contactcard.dart';
import 'package:flutter/material.dart';

class UsersSearch extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      if (query != '')
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            query = '';
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: [
        if (query.isEmpty)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Search users",
            ),
          ),
        Expanded(
          child: FutureBuilder(
            future: FirebaseHelper.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              List<Users>? locationList = snapshot.data;
              final suggestionList = locationList
                      ?.where((element) => element.displayName.toUpperCase().contains(
                            query.toUpperCase(),
                          ))
                      .toList() ??
                  [];
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ContactCard(
                    user: suggestionList[index],
                    query: query,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    indent: 16,
                    endIndent: 16,
                  );
                },
                itemCount: suggestionList.length,
              );
            },
          ),
          // child: Query$getLocations$Widget(
          //   builder: (result, {fetchMore, refetch}) {
          //     if (result.hasException) {
          //       return Text(result.exception.toString());
          //     }
          //     List<Fragment$LocationFragment>? locationList = result.parsedData?.listLocations;
          // final suggestionList = locationList
          //         ?.where(
          //           (element) =>
          //               element.fullAddress?.toUpperCase().contains(
          //                     query.toUpperCase(),
          //                   ) ??
          //               false,
          //         )
          //         .toList() ??
          //     [];
          // return ListView.separated(
          //   itemBuilder: (context, index) {
          //     return LocationCard(suggestionList[index], query);
          //   },
          //   separatorBuilder: (BuildContext context, int index) {
          //     return const SspDivider(
          //       indent: 16,
          //       endIndent: 16,
          //     );
          //   },
          //   itemCount: suggestionList.length,
          // );
          //   },
          // ),
        ),
        SafeArea(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black
                ),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Container()
          ),
        ),
      ],
    );
  }
}
