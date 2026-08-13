# Put4Ritmo-framework (**ARQUIVO**; Godot 3)
Put4Ritmo é um jogo de ritmo mobile *feito em 2023~2024* inspirado no jogo Beatstar na Godot Engine, e teve sua base nas duas "artistas" e os álbuns da [put4 records](https://www.youtube.com/@put4records) (projeto de uma pseudogravadora criada no Youtube, que envolve as pessoas Maria José "Cururu" e a Tulla Luana.)
[Confira a gameplay](https://www.youtube.com/watch?v=OaPdtUqjD2g) da edição Put4Ritmo: Sucessos do BUVA, onde tento mostrar a maioria dos recursos do jogo!

Put4Ritmo usa **charts de Clone Hero / Guitar Hero (.chart)** que são feitas usando só as **três primeiras teclas da guitarra**, mas, se a chart usar todas as 7 teclas, o script que converte o arquivo pra a linha do tempo utilizada no jogo consegue espelhar as 7 teclas em apenas 3. Escolhi esse sistema porque, inicialmente, eu usava vários mapas prontos do Clone Hero e queria tornar eles jogáveis.

O jogo é projetado pra ter **versões baseadas em álbuns** (ou em uma **coletânea de sucessos de um artista**), por exemplo, a edição piloto foi a do álbum Versus (Put4Ritmo: Versus). 
Cada edição tem **todas as músicas de um álbum**, e para **zerar** o jogo, é preciso, **ou jogar o modo álbum**, que reproduz todas as músicas de uma vez só sem pausas (modo incompleto), **ou alcançar a pontuação máxima 3 vezes em todas as músicas do jogo** (faz mais sentido quando a edição é pra uma coletânea).

## Recursos
* O jogo tem 3 tipos de **moedas próprias** (e todas elas podem ser ganhadas ao realizar tarefas): 
> * **Fichas de lista**: ganha-se 1 a cada jogatina finalizada com a pontuação máxima e é usada para jogar o modo álbum;
> * **Fichas de música**: ganha-se 1 a cada "estrela" (9000 pontos), mas sendo ela a própria estrela em si, e é usada pra comprar músicas;
> * **Mariedas**: ganha-se 1 a cada 1000 pontos na jogatina, é a moeda de menor valor e é usada pra comprar notas customizadas.
* A **compra de músicas** consiste em apenas um botão na aba loja e custa inicialmente **5 fichas de música**, quando uma música é comprada, existe **50% de chance do preço aumentar em 5 fichas;**
* A **pontuação máxima é 50000**, onde existem **5 estrelas**, que são as fichas de música;
* **As notas da jogatina podem ser customizadas!** Existe uma parte da loja que vende apenas essas customizações, para editá-las, as notas já são instanciadas no editor, só o fundo da nota que é fixo (mas a textura deste pode ser mudada também);
* **Poderes!** No jogo, existem alguns poderes (e podem existir mais, mas não tive tantas ideias acerca) são eles:
> - **Totem da Ygona** (sim, um in memoriam da Ygona Moura): vale 50 mariedas e serve para ressuscitar o jogador na sua jogatina, quando ele não clicar em alguma tecla, gastando assim um a cada ressuscitada;
> * **Mão de vaca:** vale 5 fichas de lista, é usado pra diminuir o preço da compra de uma nova música em 5 e funciona melhor quando se tem muuuitas músicas em um jogo só.
* Devo ter esquecido alguns recursos, mas vale a pena, e recomendo também, olhar o código, a pasta com as texturas, os sons e testar o jogo em si!

## Notas!
*  Esse jogo foi totalmente feito em, formalmente, "vibe coding" (informalmente: é todo troncho) mas eu só pensava em fazer um protótipo de algo divertido que eu pudesse jogar e colocar minhas charts, mas, se por algum acaso, esse jogo realmente virar uma release, eu assumo que em algumas partes, o código deveria ser mais é otimizado. p.s.: quebra um galho enorme e é todo funcional!!!

## Como criar uma versão do jogo?
*

## Para escrever:
* Terminar as TAREFAS!!
* Como criar uma versão do jogo?
* ...

## Para fazer/terminar:
* Portar pro Godot 4 (POR FAVOR ALGUÉM FORKA O REPO E FAZ POR MIM, EH O MAIOR SAAAACO)
* Suportar hold notes (notas de segurar) (em minha defesa, eu não sabia como ajustar para que a pontuação fosse dividida e as durações dessas notas tivessem incluídas)
* Escrever o "Para escrever", rs
* O modo álbum
* Suportar outros tipos de charts (osu!mania e afins)
