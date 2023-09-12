import 'package:flutter/material.dart';


import '../../../Model/Evenement.dart';
import '../../../Repository/EvenementRepository.dart';
class LesStories extends StatefulWidget {
  const LesStories({super.key});

  @override
  State<LesStories> createState() => _LesStoriesState();
}

class _LesStoriesState extends State<LesStories> {
  EvenementRepository er = new EvenementRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listes des évènements",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<List<Evenement>>(
                stream: er.obtenirTousLesEvenement(),
                builder: (context,snapshot){
                  if(snapshot.hasError){
                    print("Erreure : ${snapshot.error}");

                    return Center(child: Text("Une erreur est survenue"),);
                  }
                  else{
                    if (snapshot.hasData) {
                    return Expanded(
                    child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,bottom: 20),
                          child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage("${snapshot.data![index].image}"),

                            ),
                          ),
                          subtitle: Text(snapshot.data![index].nom),
                          title: Text(snapshot.data![index].description),
                            trailing: Container(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  snapshot.data![index].story?InkWell(
                                      onTap:(){
                                        er.RetirerUneStorie(snapshot.data![index]);
                                      },
                                      child: Icon(Icons.monitor_heart)):InkWell(
                                      onTap:(){
                                        er.AjouterStorie(snapshot.data![index]);
                                      },
                                      child: Icon(Icons.add)),

                                  SizedBox(
                                    width: 30,
                                  ),
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Icon(Icons.delete)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    }),
                    );
                    }
                    else{
                    return Center(

                    child: Text("Aucun evènement trouvé"),

                    );
                    }
                    }
                  }
            ),
          ],
        ),
      ),
    );
  }
}
