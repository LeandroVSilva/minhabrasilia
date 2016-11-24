# minhabrasilia

Projeto de IOS realizando com o objective c.
Projeto realizado para cumprir a matéria da disciplina de Desenvolvimento para iOS Apple 1 e Desenvolvimento para iOS Apple 2.

O que o app faz?
MinhaBrasilia tem o intuito de ajudar ao usuário encontrar endereços comerciais em Brasília (Asa Sul e Asa Norte).
A pesquisa é realizada por categorias (Academia, Bares, Restaurantes, ect) e por cidade (Asa Sul e Asa Norte). Assim o usuário pode procurar o que realmente deseja.
Ao escolher a cidade e a categoria, o aplicativo irá retornar a lista com os nomes e endereços. Ao clicar em uma opção, será direcionado para os detalhes onde  aparecerá a localidade do endereço no mapa e permitindo criar uma rota, buscando da sua localidade atual até o endereço selecionado.
É possível marcar o endereço como Favorito. A lista de favorito ficará salva e assim facilitando futuras pesquisas.


Arquitetura do app.
Desenvolvido no xcode utilizando objective c.
-Utilizando plist para mostrar as categorias numa tableview.
-Utilizando a consulta http com retorno em json para pesquisar no servidor os dados de endereços e informações complementares do local desejado. O retorno é tratado e mostrado numa tableview.
-Utilizando o MapKit para mostrar no map o ponto do endereço desejado.
-Utilizando Core Location para permitir traçar a rota da posição atual do usuário até o endereço desejado. (O app informa a necessidade de utilizar o gps).
-Utilizando o Core Data para salvar e controlar a marcação dos favoritos.
-Utilizando Auto Layout.

