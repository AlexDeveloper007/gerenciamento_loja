class ProdutoValidator{

  String validarImagens(List imagens){
    if(imagens.isEmpty){
      return "Adicione imagens do produto";
    }else{
      return null;
    }
  }

  String validarTitulo(String text){
    if(text.isEmpty){
      return "Preencha o título do produto";
    }else{
      return null;
    }
  }

  String validarDescricao(String text){
    if(text.isEmpty){
      return "Preencha a descrição do produto";
    }else{
      return null;
    }
  }

  String validarPreco(String text){
    double preco = double.tryParse(text);
    if(preco != null){

      //verifiar se o preço tem apenas 2 casas decimais
      if(!text.contains(".") || text.split(".")[1].length != 2){
        return "Utilize 2 casas decimais";
      }

    }else{
      return "Preço inválido!";
    }
    return null;
  }

}
