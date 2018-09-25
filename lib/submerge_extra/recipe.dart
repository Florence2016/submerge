class Recipe {
  //String title, thumbnail, href, ingredients;
  String title, link, snippet;
  Recipe(
      {this.title,
        this.link,
        this.snippet,
        });

  Recipe.fromJson(dynamic recipe) {

    try {
      this.title = recipe['title'];
      this.link=recipe['link'];
      this.snippet = recipe['snippet'];
      //this.thumbnail = (recipe['thumbnail']);
      if(recipe['thumbnail'].toString().length==0){
        //this.thumbnail = 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/No_image_available_600_x_450.svg/600px-No_image_available_600_x_450.svg.png';
      }

    } catch (e) {
      print("something happened"+e.toString());
    }
  }
}