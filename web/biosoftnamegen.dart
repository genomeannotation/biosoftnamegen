import 'dart:html';
import 'dart:math' show Random;
import 'dart:convert' show JSON;
import 'dart:async' show Future;

NameGen nameGen = new NameGen();

void main() {
  NameGen.readNames()
    .then((_) {
      // on success
    querySelector("#abbreviation").text = "Click for inspiration.";
    querySelector("#container").onClick.listen(addNewBioSoftName);
  })
      // on failure
  .catchError((oops)  {
    print("error reading names from json");
    print(oops);
    querySelector("#name").text = "Error reading JSON; try again later.";
  });  
}

void addNewBioSoftName(MouseEvent event) {
  List namePair = nameGen.getNamePair();
  String newAbbrev = namePair[0];
  String newName = namePair[1];
  querySelector("#abbreviation").text = newAbbrev;
  querySelector("#name").text = newName;
}



class NameGen {
  static Random rng = new Random();
  static List adjectivePhrases;
  static List domains;
  static List actions;
  static List doers;
  
  NameGen() {
    List adjectivePhrases = [];
    List domains = [];
    List actions = [];
    List doers = [];
  }
  
  static Future readNames() {
    var path = "names.json";
    return HttpRequest.getString(path)
              .then(parseNames);
  }
  
  static parseNames(String namestring) {
    Map names = JSON.decode(namestring);
    adjectivePhrases = names['adjective phrases'];
    domains = names['domains'];
    actions = names['actions'];
    doers = names['doers'];
  }
  
  List getNamePair() {
    // get adjective phrase, maybe.
    List adjPhraseList;
    String adjPhrase = "";
    String adjPhraseAbbrev = "";
    double adjPhraseProb = rng.nextDouble();
    if (adjPhraseProb > 0.5) {
      adjPhraseList = randomListFromList(adjectivePhrases);
      adjPhrase = adjPhraseList[0] + " ";
      adjPhraseAbbrev = randomStringFromList(adjPhraseList[1]);
    } 
    
    // get domain
    List domainList = randomListFromList(domains);
    String domain = domainList[0] + " ";
    String domainAbbrev = randomStringFromList(domainList[1]);
    
    // get action, maybe
    List actionList;
    String action = "";
    String actionAbbrev = "";
    double actionProb = rng.nextDouble();
    if (actionProb > 0.5) {
      actionList = randomListFromList(actions);
      action = actionList[0] + " ";
      actionAbbrev = randomStringFromList(actionList[1]);
    }
    
    // get doer
    List doerList = randomListFromList(doers);
    String doer = doerList[0];
    String doerAbbrev = randomStringFromList(doerList[1]);
    String abbrev = adjPhraseAbbrev + domainAbbrev + actionAbbrev + doerAbbrev;
    String name = adjPhrase + domain + action + doer;
    if (startsWithAVowel(name)) {
      name = "An " + name;
    } else {
      name = "A " + name;
    }
    if (abbrev.length < 3) {
      return getNamePair();
    } else {
      return [abbrev, name];
    }
  }
  
  List randomListFromList(List myList) {
    int index = rng.nextInt(myList.length);
    return myList[index];
  }
  
  String randomStringFromList(List myList) {
    int index = rng.nextInt(myList.length);
    return myList[index];
  }
  
  bool startsWithAVowel(String word) {
    String vowels = "AEIOUaeiou";
    if (vowels.contains(word[0])) {
      return true;
    } else {
      return false;
    }
  }  
}