#1º passo Usando o syuzhet
library(syuzhet)

#2º passo: coisa usei o texto editorial da globo sobre reforma da previdëncia
## https://oglobo.globo.com/opiniao/reforma-coerente-enfrenta-desafio-da-politica-23466955

#3º passo: Traduzir para o inglës 

#4º passo: Retirar todas as aspas e apostrofos e separa-las em sentenças finalizando a cada ponto final

#5ºpasso criar um vetor com o texto
meu_texto <- c("The formal presentation of the pension reform proposal has confirmed the impression taken from some anticipations made and statements from authorities that it is coherent and addresses the need, among other things, for correcting injustices between security regimes.
                     In addition, of course, to signal that the Brazilian State will leave the route of insolvency in which it is now, due to uncontrolled social security expenditures. 
                     In this sense, this is the most complete security reform project ever presented, since the issue entered the country's agenda with Fernando Henrique Cardoso's inauguration in 1995. 
                     For the problem of growing Welfare imbalances is old, and all the changes that FH, Lula and Dilma were able to do, or wanted to carry out, never went deep into the attack at various points of the system: among others, early retirements; a large gap between the benefits paid to employees in the private sector and to the civil service, in the latter's privilege; and a firm response to the inexorable tendency of the Brazilian system, based on the distribution system, to be made impossible by time, even in the long term, by the inevitable accelerated aging of the population, by the fall in birth rate and a welcome survival of who reaches the age of 62 and 65, which may be the age limit for the retirement of women and men, if the proposed constitutional reform is now approved.
                     The presentation of the New Social Security coincides with the exotic crisis a policy created within President Bolsonaro's family that resulted in the exoneration of Presidential Secretary General Gustavo Bebianno, who was already demonstrating some transit in Congress and would help Onyx Lorenzoni, chief minister of the Civil House, in the crucial task of negotiating in the Legislature the approval of the reform. 
                     It will be an additional challenge for the government. 
                     But he has in his favor a set of well-stoned measures.
                     Even the classic criticism of any pension reform, made mainly by those who want to keep privileges, that the billions of debts to the INSS should be charged beforehand, has a response: a bill will be presented to facilitate the collection of this liability and restrain indebted debtors.
                     Another positive point is the perception that, after all, politicians and society begin to understand the problem of Social Security, and that without its equation the economy will not grow again as Brazil needs. 
                     It is possible that the persistent and high unemployment caused by the great recession of the 2015/16 biennium, derived from the errors of the economic policy of Dilma / Lula, is playing a pedagogical role in society on the imperative necessity of this fiscal adjustment.
                     Temer's reform, in its original design, aimed at $ 800 billion of economy in ten years. 
                     A de Bolsonaro, R $ 1072 trillion, a figure essential to reverse the trend of growth of public debt in GDP 50% in the first Dilma government and which, due to its errors, is close to 80%. 
                     The search for the equalization of rules between the various regimes, the reform of the military system, easier, because it is by bill, will come later, including the principle that those who have higher pay contributes more, transposed from Income Tax to social security contribution , is consistent with the quest for social justice.
                     Something unassailable as a principle. 
                     Such a wide range of proposals will take some time to digest in and out of Congress. 
                     It is not possible, in the debate, to lose all sense of the proposals and the understanding that, although it is an emergency reform, it opens a long-term horizon, as shown by the inclusion in the new capitalization package for the young . 
                     This opportunity should not be missed to open a wide area of growth for the country.")

#6º passo: Analisando o texto atraves do método NRC, pode testar om bing e outros
sentimento <- get_nrc_sentiment(meu_texto)


#7º passo: Criando umg gráfico com os resultados
barplot(colSums(sentimento),las = 2,ylab = "Quantidade",main = "Sentimento")

#8º passo: Abrindo o gráfico e mostrando as observações por tipo de sentimento
sentimento

#9º passo: Abrindo os dados por tipo
sentimento$trust

#10º passo Criar tabela mais sofisticada usando o Pander sem as colunas 9(negat) e 10(posit)
library(pander)
pander::pandoc.table(sentimento[,1:8], split.table = Inf)


#11 passo: Analisando somente os pontos positivos e negativos
pander::pandoc.table(sentimento[, 9:10])

#11º passo: Plotando outro tipo de gráfico virado
barplot(sort(colSums(prop.table(sentimento[, 1:8]))), horiz = TRUE, cex.names = 0.7, 
  las = 1,  main = "Emoções no texto analisado", xlab="%")


##Fim e abaixo tem novos testes em andamento ========================

#Testando com novo texto em portugues
novo_texto <- c("Eu gostei do novo modelo do fox.
                Mas bem que poderia ser mais barato, esta muito caro.
                A cor poderia ser melhor, nunca vi uma cor tão feia.
                Mas a garantia é excelente, gostei da garantia.")

#12º Criando um vetor com a lingua pra simplificar e rodando a função get_nrc_sentiment
lang <- "Portuguese"
novo_sentimento <- get_nrc_sentiment(novo_texto, language = lang)

novo_sentimento

#13º Plotando gráfico no novo_sentimento
barplot(colSums(novo_sentimento),las = 2,ylab = "Quantidade",main = "Sentimento")

??syuzhet

#Em outras linguas senao o ingles é necessário chamar outras funções
path_to_a_text_file <- system.file("extdata", "quijote.txt",package = "syuzhet")
my_text <- get_text_as_string(path_to_a_text_file)
char_v <- get_sentences(my_text)
method <- "nrc"
lang <- "spanish"
my_text_values <- get_sentiment(char_v, method=method, language=lang)
my_text_values[1:10]


#criando table personalizada apontando a palavra e o valor 
my_text <- "I love when I see something beautiful.  I hate it when ugly feelings creep into my head."
char_v <- get_sentences(my_text)
method <- "custom"
custom_lexicon <- data.frame(word=c("love", "hate", "beautiful", "ugly"), value=c(1,-1,1, -1))
my_custom_values <- get_sentiment(char_v, method = method, lexicon = custom_lexicon)
my_custom_values

# A coleta de resultados de sentimento em grandes volumes de dados pode ser demorada. Pode-se chamar get_sentiment e fornecer informações de cluster de parallel :: makeCluster () para obter resultados mais rápidos em sistemas com múltiplos núcleos. Por exemplo, em Madame Bovary como acima:
library(parallel)
cl <- makeCluster(2) # or detect_cores() - 1
clusterExport(cl = cl, c("get_sentiment", "get_sent_values", "get_nrc_sentiment", "get_nrc_values", "parLapply"))
bovary_sentiment_par <- get_sentiment(bovary_v, cl=cl)
bovary_nrc_par <- get_sentiment(bovary_v, method='nrc', cl=cl)
stopCluster(cl)
