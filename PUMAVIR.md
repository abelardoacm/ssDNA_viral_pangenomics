# Estudio pangenómico de los virus de DNA de cadena sencilla

> Alumno: Abelardo Aguilar Cámara </br> Tutor: Arturo Carlos II Becerra Bracho </br></br> Laboratorio de Origen de la Vida, Facultad de Ciencias  </br> UNAM, Posgrado en Ciencias Biológicas </br> </br>


> Nota al lector: El presente archivo tiene como formato original el ***Github flavored markdown***, por lo que recomendamos su acceso vía internet, mediante el vínculo [https://github.com/abelardoacm/ssDNA_viral_pangenomics/edit/main/PUMAVIR.md](https://github.com/abelardoacm/ssDNA_viral_pangenomics/edit/main/PUMAVIR.md)

## Introducción 

### Virus SSDNA 


Los virus de DNA de cadena sencilla (ssDNA) conforman el grupo II de la clasificación de Baltimore<sup>[1](#referencias)⁠</sup>. Algunos estudios han postrado que los virus de ssDNA están presentes en gran número de habitats, desde ventilas hidrotermales hasta el intestino de los humanos y otros animales.  Están ampliamente distribuidos e incluyen patógenos económica, médica y ecológicamente importantes<sup>[2](#referencias)⁠</sup>. Se distinguen por tener una estructura genomica mayoritariamente circular, con tamaños del genoma entre 1.7 y 25 kb, la mayoría tienen genomas no segmentados, sus huéspedes son bacterias, algunas arqueas y la mayoría de grupos de eucariontes<sup>[3](#referencias)⁠</sup>⁠. Los virus ssDNA incluyen algunos de los genomas mas pequeños y simples, entre 2-6 kb de longitud. A pesar de que hay familias que pueden codificar solo una proteína estructural y una implicada en la replicación del DNA,  también existen casos más complejos, como la familia Nanoviridae, en el que el genoma completo esta compuesto por 6-8 segmentos de ssDNA de ~1-kb<sup>[4](#referencias)⁠</sup>. Actualmente el comité internacional de taxonomía de virus clasifica a los virus ssDNA en 15 diferentes familias<sup>[5](#referencias)⁠</sup>⁠.

#### CRESS DNA 

El conocimiento actual de este grupo se centra en los virus CRESS DNA, que abarca la mayoría de los ssDNA<sup>[6](#referencias)⁠</sup>. El termino “CRESS DNA” se refiere al grupo de virus de DNA de cadena sencilla (ssDNA) que codifican la proteína asociada a la replicación (Rep) que se pensaba tenían un ancestro común, hasta que Kazlauskas y colaboradores (2019) realizaron una red filogenética que sugiere el surgimiento de estos virus en por lo menos tres eventos. Los virus CRESS DNA infectan tanto arqueas como bacterias, aunque sus proteínas Rep son diferentes<sup>[6](#referencias)⁠</sup>.  La mayoría de las familias de virus de cadena sencilla (definidas por ICTV) tienen genomas circulares, exceptuando a Parvoviridae y Bidnaviridae<sup>[5](#referencias)⁠</sup>. Entre las familias de virus con DNA de cadena sencilla con genomas circulares, siete infectan organismos eucariontes, siendo Anelloviridae la única familia que no codifica proteínas Rep homólogas. Las seis familias de virus CRESS DNA de eucariontes son Bacilladnaviridae, Circoviridae, Geminiviridae, Genomoviridae, Nanoviridae y Smacoviridae <sup>[6](#referencias)⁠</sup>.  


### Los virus ssDNA y el estudio del origen de la vida

A pesar del continuo debate sobre considerar o no a los virus como seres vivos, los virus son un eje extremadamente importante en la evolución de la biósfera, pues su se relaciona íntimamente con la de sus hospederos<sup>[7](#referencias)⁠</sup>.Una de las preguntas principales que debemos intentar responder es, ¿desde cúando debemos tomar en cuenta dicha relación?, para ello, es necesario abordar el origen y evolución temprana de los virus. El posible rol de los virus en el origen de la vida, depende del origen u orígenes mismos de los virus.

Existen distintas teorías sobre el origen de los virus, que datan su aparición en momentos muy distintos. Podemos agruparlas en:

- **Ideas Virocénctricas**: Proponen que los virus surgieron antes que los organismos celulares, y que proporcionaron la materia prima para el origen de las primeras células. Está soportada por *hallmark genes*, genes virales sin homólogos celulares conocidos<sup>[8](#referencias)⁠</sup>.

- **Regresión Celular**: Los virus tuvieron un origen post-celular temprano, mediante una contracción genómica a partir de múltiples linajes celulares ancestrales con RNA genómico, constituyendo así un cuarto dominio de la vida<sup>[9](#referencias)⁠</sup>Esta teoría surge a partir de particularidades genómicas de los *Mimiviridae*, virus de DNA de doble cadena con genomas de ~1200 kb y presencia de genes con funciones metabólicas.

- **Hipótesis de Escape**: Múltiples orígenes post-celulares tardíos. Sostiene que los virus surgen a partir de secuencias genómicas escapadas que adquieren independencia, convirtiéndose en entidades replicativas autónomas. Está soportada por la homología entre secuencias virales y celulares, particularmente de sus hospederos<sup>[10,11](#referencias)⁠</sup>.

- **Hipótesis coevolutiva**: Origen celular y viral simultáneo. Intercambio de módulos coevolutivos de proteínas exclusivamente virales y celulares mediante transferencia horizontal<sup>[12](#referencias)⁠</sup>.

Los virus ssDNA podrían ser considerados antiguos en consonancia con las ideas virocéntricas, debido a ser considerados simlpes con genomas muy pequeños <sup>[4](#referencias)⁠</sup> que cambian rápidamente <sup>[13](#referencias)⁠</sup>. En contraste, existen indicios recientes que proponen múltiples orígenes tardíos a partir de escapes genómicos de la proteína Rep <sup>[11](#referencias)⁠</sup>, una helicasa que permite iniciar la replicación vía *rolling circle*<sup>[6](#referencias)⁠</sup>. Sin embargo, no todos los virus ssDNA codifican dicha proteína, y existen conformaciones genómicas muy complejas como los **Nanoviridae**, por lo que dichas conclusiones podrían no extenderse a todas las familias.

### Estudio pangenómico

Los virus son un grupo politético, clasificados en lo general por la forma en que sintetizan su mRNA, pero sin un marcador universal<sup>[3](#referencias)⁠</sup>. Sin embargo, en escalas menores, por ejemplo a nivel de familia, existen elementos genéticos conservados, particularmente aquellos implicados en procesos de replicación, empaquetamiento del genoma y síntesis del mRNA, y que pueden ser utilizados como marcadores filogenéticos para trazar relaciones profundas sobre su propio origen<sup>[14](#referencias)⁠</sup>. La pangenómica es un método de análisis que permite categorizar grupos de genes homólogos de acuerdo a su prevalencia entre los genomas de un linaje<sup>[15](#referencias)⁠</sup>, a partir de la cual podemos escoger marcadores para comenzar un análisis evolutivo, primero asignando los genes del linaje a tres grupos pangenómicos:

- ***Core***: Genes presentes en todos los miembros del linaje.
- ***Soft-Core***: Genes con prevalencia > 90% , < 100%.
- ***Shell***:Genes ampliamente distribuidos y esenciales, que no alcanzan una prevalencia del 100%.
- ***Cloud***: Genes específicos a un grupo de miembros del linaje.

## Objetivo

El presente estudio tiene como objetivo indagar la historia evolutiva de los virus de DNA de cadena sencilla a nivel de familia, generando un catálogo de genes homólogos en función de su prevalencia en cada una de ellas.

#### Objetivos particulares
  - Identificar los elementos que componen el núcleo, cubierta y nube del pangenoma, para extender búsquedas de homólogos remotos.
  - Contrastar las filogenias de las secuencias virales y sus homólogos con las hipótesis del origen de los virus.
  - Detectar elementos genéticos de los virus ssDNA que puedan ser relacionados a los genomas de sus hospederos.

## Métodos 

#### Configuración de la base de datos: descarga, concatenado y filtrado.
Los proteomas virales fueron descargados por familia, utilizando la siguiente búsqueda general en NCBI refseq:
```
Familia [ORGANISM] AND srcdb_refseq[PROP] NOT wgs[prop] NOT cellular organisms[Organism] NOT AC_000001:AC_999999[pacc]

```
Esta búsqueda permitió la obtención de proteomas completos y parciales para las familias segmentadas (Nanoviridae, Bidnaviridae y Geminiviridae). Debido a que la pangenómica evalúa la prevalencia de los grupos de homólogos y los clasifica de acuerdo a la teoría de conjuntos, opera bajo el supuesto de que la carpeta de *input* contiene genomas completos. Para evitar la subestimación errónea del núcleo pangenómico, se utilizó un script en ***bash*** encargado de identificar archivos provenientes del mismo organismo, para concatenarlos en genomas completos. Un segundo filtro de calidad fue implementado, pues debido a errores en la anotación e inclusión de los archivos en NCBI refseq, es posible encontrar archivos sin secuencias protéicas o genomas mal anotados como virales. Por cada una de las familias, se efectuó el conteo de proteínas por proteoma, descartando aquellos que variaran en ± el 45% del valor más observado por familia.

#### Agrupamiento pre-pangenómico

Dada la escala del análisis se realizaron agrupamientos entre los genomas de cada familia, para prevenir la subestimación de la prevalencia. En primer lugar se calculó una matriz de distancias pareadas a nivel proteómico, mediante un algoritmo libre de alineamientos, basado en el análisis de Fourier<sup>[16](#referencias)⁠</sup>. Este método estima un vector 28-dimensional por cada genoma con una correspondencia 1 a 1, el cual permite la obtención de distancias euclideanas pareadas. Tanto los vectores y matrices de distancias pareadas fueron utilizadas como *input* para el paquete de *R*{NbClust}<sup>[17](#referencias)⁠</sup>, mediante el cual se obtuvieron agrupamientos pre-pangenómicos. Los sub-grupos generados fueron filtrados a un mínimo de 5 proteomas, necesario para el operar de los algoritmos pangenómicos.

#### Análisis pangenómico y post-pangenómico

Mediante un script en *bash* se utilizó el programa **GET_HOMOLOGUES**<sup>[18](#referencias)⁠</sup> utilizando los algoritmos de agrupamiento **COGtriangles** y **OrthoMCL** por cada grupo pre-pangenómico obtenido en el paso anterior. Los parámetros fueron modificados a  *query coverage* > 30, *e-value* < 1e<sup>-3</sup> y la opción *-D* que efectúa la búsqueda de perfiles de Pfam y restringe el agrupamiento en *clusters* pangenómicos a sólo aquellas secuencias con una conformación similar en dominios de Pfam.

Todos los datos, scripts utilizados y su descripción detallada se encuentran disponibles en el repositorio de github [abelardoacm/ssDNA_viral_pangenomics/](https://github.com/abelardoacm/ssDNA_viral_pangenomics/).

## Resultados

#### Base de datos

La descarga de los proteomas completas permitió obtener un total de  3576 proteomas crudos iniciales (tabla 1) . El concatenado de los archivos en el caso de los virus segmentados, tuvo impacto en el número de archivos de las familias Nanoviridae, Bidnaviridae y Geminiviridae, así como un impacto clave en su estimación pangenómica, discutido más adelante. Finalmente el filtrado por conteo de proteínas concluyó con 2966 proteomas.

Tabla 1. **Configuración de la base de datos**
| Familia            | # inicial | # post-concatenado | # post-filtrado |
|--------------------|-----------|--------------------|-----------------|
| Alphasatellitidae  | 100       |                    | 93              |
| Anelloviridae      | 108       |                    | 98              |
| Bacilladnaviridae  | 9         |                    | 8               |
| Bidnaviridae       | 4         | **2**              | 2               |
| Circoviridae       | 216       |                    | 191             |
| Geminiviridae      | 704       | **538**            | 512             |
| Genomoviridae      | 108       |                    | 104             |
| Inoviridae         | 43        |                    | 42              |
| Microviridae       | 62        |                    | 57              |
| Nanoviridae        | 91        | **12**             | 12              |
| Parvoviridae       | 144       |                    | 143             |
| Pleolipoviridae    | 14        |                    | 10              |
| Smacoviridae       | 51        |                    | 49              |
| Spiraviridae       | 1         |                    | 1               |
| Tolecusatellitidae | 136       |                    | 123             |

#### Grupos pre-pangenómicos

Todas las familias con 10 o más genomas en la configuración final de la base de datos generaron sub-agrupamientos (tabla 2). Las familia con más subgrupos, **Inoviridae** corresponde también con la de mayor tamaño genómico 4.5 ~ 8 Kb, es decir, más vías de diferenciación. De los 47 grupos pre-pangenómicos, 39 fueron aptos para el análisis pangenómico, quedando descartadas únicamente las familias de satélites.

<p align="center">
  <b>Tabla 2. Número de subgrupos por familia, encontrados mediante NbClust.</b><br>
</p>

| Familia            | # sub-grupos | # apto para pangenómica |
|--------------------|--------------|-------------------------|
| Alphasatellitidae  | 5         | 3 |
| Anelloviridae      | 2         | 4 |
| Bacilladnaviridae  | 2         | 2 |
| Circoviridae       | 3         | 4 |
| Geminiviridae      | 2         | 3 |
| Genomoviridae      | 2         | 4 |
| Inoviridae         | 8         | 4 |
| Microviridae       | 4         | 3 |
| Nanoviridae        | 3         | 2 |
| Parvoviridae       | 3         | 3 |
| Pleolipoviridae    | 2         | 2 |
| Smacoviridae       | 2         | 3 |
| Tolecusatellitidae | 4         | 2 |

Los agrupamientos realizados en NbClust, pudieron ser visualizados mediante análisis de componentes principales *PCA*, como el mostrado para la familia Geminiviridae (figura 1). En el podemos observar una total separación entre los proteomas, considerando únicamente 2 de las 28 dimensiones del vector construido. En contraste, la familia Inoviridae muestra un esquema complejo de 8 sub-grupos sin una separación total. Por motivos de espacio no fueron mostrados todos los PCA de los agrupamientos, pero se encuentran disponibles en el repositorio de github [abelardoacm/ssDNA_viral_pangenomics/](https://github.com/abelardoacm/ssDNA_viral_pangenomics/).

<p align="center">
  <img width="700" height="500" src="https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/GemClusts1.png">
</p>

<p align="center">
  <b>Figura 1. PCA del agrupamiento de los proteomas de la familia Geminiviridae. Puede observarse en color azul y anaranjado, a los miembros del cluster 1 y 2 respectivamente.</b><br>
</p>

<p align="center">
  <img width="700" height="500" src="https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/inoviridae.png">
</p>

<p align="center">
  <b>Figura 2. PCA del agrupamiento de los proteomas de la familia Inoviridae. Esquema complejo de 8 sub agrupamientos.</b><br>
</p>

#### Efecto de los filtros de calidad y pre-agrupamientos en la subestimación

El impacto de las medidas orientadas a evitar la subestimación del núcleo pangenómico fue evidente en las familias con genomas segmentados (figura 3). Para el caso de la familia Nanoviridae, dichas medidas marcaron la diferencia entre la existencia o no del núcleo pangenómico. 

<p align="center">
  <img width="900" height="500" src="https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/nanoefectos.png">
</p>

<p align="center">
  <b>Figura 3. Efecto de las medidas anti-subestimación pangenómica para la familia Nanoviridae.</b><br>
</p>

Como puede observarse, en el lado izquierdo (sin medidas) no pudo encontrarse un núcleo pangenómico, y las diferencias entre las prevalencias de los grupos homólogos no permitieron la postulación de genes candidatos para extender la búsqueda de homólogos remotos. En contraste, los filtros de calidad, objetivos y automatizables condujeron a mejores resultados pangenómicos.

#### Pangenomas

Como fue mencionado previamente, el pangenoma se construye a partir del repertorio genético de los miembros de un linaje. En nuestro caso, los linajes fueron abordados a nivel de familia. A continuación se muestran gráficas que ilustran el tamañi de los grupos pangenómicos por prevalencia, con la finalidad de distinguir el componente pangenómico más observado. Por limitaciones de espacio, se muestran gráfucas que corresponden a la salida de **GET_HOMOLOGUES** solo para aquellos sub-gruposmás inclusivos por familia, es decir, los que están conformads por más proteomas.

|   |   |   |
|---|---|---|
|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/anelloclusts.png)| ![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/bacillaclusts.png)|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/circoclusts.png)|
|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/geminiclusts.png)| ![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/genomoclusts.png)|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/inoclusts.png)|
|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/microclusts.png)| ![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/nanoclusts.png)|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/parvoclusts.png)|
|![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/pleolipoclusts.png)|  |  |

<p align="center">
  <b>Figura 4. Gráficas de proporción de grupos pangenómicos.</b><br>
</p>


Como puede observarse, el núcleo pangenómico existe únicamente para las familias Bacilladnaviridae, Geminiviridae y Nanoviridae, siendo las dos últimas, familias con genomas segmentados.

#### Características destacables del ***core*** y ***soft-core*** pangenómico.

Posterior a la obtención de *clusters* pangenómicos, procedimos a la exploración de las proteínas que los conforman, con un particular énfasis en *core* y *soft-core*. Como fue mencionado anteriormente, no existe un elemento genético presente en todas las familias, por lo que tampoco se obtuvo un *cluster* pangenómico común a todas. Una de las proteínas esperadas en *clusters* de alta prevalencia es la Helicasa Rep entre las familias del grupo CRESS DNA (tabla 3). Contario a lo esperado, esta proteína no pudo ser encontrada en todos los proteomas CRESS DNA, aunque esta formó parte del *core* en la mayoría de los pangenomas. 


<p align="center">
  <b>Tabla 3. Prevalencia de la proteína Rep en los virus CRESSDNA</b><br>
</p>


| Familia            | prevalencia promedio | grupo pangenómico |
|--------------------|--------------|-------------------------|
| Bacilladnaviridae  | 100%         | *core* |
| Circoviridae       | 60%         | *core*,*core*,*shell* |
| Geminiviridae      | 100%         | *core*,*core* |
| Genomoviridae      | 99%         | *core*,*soft-core* |
| Inoviridae         | 82%         | *soft-core*,*shell* |
| Microviridae       | 94%         | *soft-core*,*soft-core* |
| Nanoviridae        | 100%         | *core* |
| Parvoviridae       | 96%         | *core*,*soft-core* |
| Smacoviridae       | 98%         | *soft-core*,*soft-core* |

Un resumen general de las proteínas con alta prevalencia que formaron parte de los *cores* y *soft-cores* pangenómicos pueden observarse en la tabla 4.

<p align="center">
  <b>Tabla 4. Proteínas de alta prevalencia (core y soft-core) por familia.</b><br>
</p>


| Familia            | Proteínas de alta prevalencia |
|--------------------|--------------|
| Alphasatellitidae  |     sin agrupamientos de homólogos     |
| Anelloviridae      | *Capsid protein*         |
| Bacilladnaviridae  | *Rep, Capsid protein*         |
| Circoviridae       | *Rep, Capsid protein*         |
| Geminiviridae      | *Rep, Capsid protein*, *Movement protein*        |
| Genomoviridae      | *Rep, Coat protein*         |
| Inoviridae         | *Rep*,*DNA-Binding*, *Capsid protein*         |
| Microviridae       | *Rep*, *Major Spike*, *Lysis protein*        |
| Nanoviridae        | *Rep*, *C-Link*         |
| Parvoviridae       | *Rep*, *Capsid*        |
| Pleolipoviridae    | *Envelope*, *Matrix Protein*, *VP*   |
| Smacoviridae       | *Putative capsid protein*        |
| Tolecusatellitidae |      sin agrupamientos homólogos     |

#### Discusión

La conformación de la base de datos permitió obtener una muestra no redundante y representativa de proteomas por familia. Debido a la alta cantidad de archivos generados en tan solo los primeros pasos del análisis, la automatización de los procesos jugó un rol crucial. Debido a ello el establecimiento de criterios objetivos para concatenar y filtrar los proteomas surgió como una necesidad en el manejo. A pesar de que los valores de corte para dichos filtros puede ser sujeto de debate, las distintas repeticiones (no mostradas) condujeron al conjunto de parámetros presentados. 

Para aquellas familas donde los archivos obtenidos no permitieron desarrollar el análisis pangenómico, debe considerarse que el estado actual del conocimiento está muy sesgado a virus ssDNA que infectan eucariontes, particularmente las familias Geminiviridae y Genomoviridae que constituyen más del 90% de la diversidad de los proteomas utilizados. Para sobrellevar esta limitante, puede optarse por consultar bases de datos con un escrutinio menor que el de NCBI refseq en los criterios de inclusión, incluso ampliando hasta la inclusión de muestras ambientales, que guardan una enorme diversidad latente de las familias menos conocidas <sup>[19,20](#referencias)⁠</sup>

La pangenómica es un área de reciente surgimiento <sup>[15](#referencias)⁠</sup>, surgida por la necesidad de abordar la enorme cantidad de secuencias conocidas para la microbiota. No obstante, algunos de sus supuestos teóricos entorno a las generalidades de los procesos de flujo de información, son difíciles de extrapolar a las particularidades evolutivas que presentan los virus. Además, los virus de DNA de cadena sencilla pueden incluso ser considerados como parte del "mobiloma", una intrincada red de intercambio genético entre elementos móviles <sup>[11](#referencias)⁠</sup>. Por ello, no existe un marco conceptual ni metodológico basto para iniciar su uso con proteomas virales. La necesidad de utilizarlos se justifica principalmente en el desconocimiento de su origen y evolución temprana, donde han fracasado otros métodos de la genómica comparada e incluso la sistemática <sup>[3](#referencias)⁠</sup>.

Si bien fue posible generar pangenomas para casi todas las familias del grupo, los resultados hasta este procedimiento suponen aún más preguntas que las que podamos responder. La cantidad de datos puede resultar abrumadora, pero el hecho de generar categorizaciones basadas en la prevalencia, brinda una base sistematizada de exploración y recabado de otros datos, por ejemplo búsquedas de homólogos remotos o inclusión de estructuras tridimensionales. 

El listado final de proteínas de alta prevalencia (tabla 4) es apenas un esbozo de la diversidad observada. Una limitante muy fuerte, es la falta de anotación, o anotaciones ambiguas de los proteomas recabados.

#### Estado actual del proyecto

Para sobrellevar las limitantes introducidas, el trabajo actual en el proyecto se centra en las siguientes líneas:
 - **Automatización**. La investigación del origen y evolución temprana de los virus ha sido establecida como línea formal de investigación en el laboratorio de origen de la vida. Esto implica la participación de múltiples estudiantes, que abordarán tareas muy similares. En este sentido, el presente trabajo ha fungido como pionero en el establecimiento de herramientas de manipulación de datos previos a la pangenómica. Dichas herramientas han sido desarrolladas bajo los principios de la reproducibiliad de la ciencia y, en medida de lo posible, apegadas a las buenas prácticas de programación. El repositorio [abelardoacm/ssDNA_viral_pangenomics/](https://github.com/abelardoacm/ssDNA_viral_pangenomics/) es el recipiente digital en desarrollo del código implementado para dicho propósito.
 - **Incorporación de otros proteomas**: Como fue anticipado, actualmente se trabaja en la inclusión de proteomas provenientes de distintas bases de datos. Los distintos formatos en que estas secuencias son presentadas requiere la implementación de procesos de manipulación desde su descarga.
 - **Búsqueda de homólogos remotos**: Comenzando con las proteínas de alta prevalencia, nos encontramos generando búsquedas de homólogos remotos mediante perfiles, utilizando la herramienta hmmsearch. Las secuencias obtenidas serán utilizadas en la elaboración de redes de distancia para dilucidar los complejos orígenes de las familias virales.
 - **Anotación de secuencias**: La prevalencia de una proteína, no siempre es proporcional a lo que sabemos de ella. La anotación ambigua de las secuencias ha supuesto una limitante para poder concluir entorno a sus funciones y procesos desempeñados. Para ello nos encontramos realizando anotaciones basadas en homología, utilizando BLAST contra una base de datos de referencia construida recabando información curada desde Uniprot, así como también experimentamos en la inclusión de métodos de anotación *de novo* de creciente popularidad.


### Referencias
> 1.	Baltimore, D. Expression of animal virus genomes. Bacteriol. Rev. 35, 235–241 (1971)
> 2.	Krupovic, M. & Forterre, P. Single-stranded DNA viruses employ a variety of mechanisms for integration into host genomes. Ann. N. Y. Acad. Sci. 1341, 41–53 (2015)
> 3.	Koonin, E. V., Krupovic, M. & Agol, V. I. The Baltimore Classification of Viruses 50 Years Later: How Does It Stand in the Light of Virus Evolution? Microbiol. Mol. Biol. Rev. 85, (2021)
> 4.	O’Carroll, I. P. & Rein, A. Viral Nucleic Acids. Encyclopedia of Cell Biology vol. 1 (Elsevier Ltd., 2016)
> 5.	Walker, P. J. et al. Changes to virus taxonomy and the Statutes ratified by the International Committee on Taxonomy of Viruses (2020). Arch. Virol. 165, 2737–2748 (2020)
> 6.	Zhao, L., Rosario, K., Breitbart, M. & Duffy, S. Eukaryotic Circular Rep-Encoding Single-Stranded DNA (CRESS DNA) Viruses: Ubiquitous Viruses With Small Genomes and a Diverse Host Range. Advances in Virus Research vol. 103 (Elsevier Inc., 2019)
> 7. Edwards R.A., Rohwer F. Viral metagenomics. 2005,Nat Rev Microbiol.3:504–10
> 8. Koonin, E. V., Kuprovic, M., & Yutin, N. Evolution of double-stranded DNA viruses of eukaryotes: from bacteriophages to transposons to giant viruses.2006, Annals of the New York Academy of Sciences.1342, 10-24
> 9. Raoult, D. et al. The 1.2‐megabase genome sequence of Mimivirus. 2004, Science.306,1344–1350
> 10. Holmes, E. C. The Evolution and Emergence of RNA Viruses. 2009,Oxford University Press
> 11. Kazlauskas D, Varsani A, Koonin EV, Krupovic M. Multiple origins of prokaryotic and eukaryotic single-stranded DNA viruses from bacterial and archaeal plasmids. Nat Commun. 2019 Jul 31;10(1):3425. doi: 10.1038/s41467-019-11433-0. PMID: 31366885; PMCID: PMC6668415
> 12. Domingo, E. Virus as Populations: Composition, Complexity, Dynamics and Biological Implications. 2005,Academic Press
> 13. Sanjuán, R. & Domingo-Calap, P. Mechanisms of viral mutation. Cell. Mol. Life Sci. 73, 4433–4448 (2016).
> 14. Jácome R., Becerra A., Ponce de León S., Lazcano A. Structural Analysis of Monomeric RNA-Dependent Polymerases: Evolutionary and Therapeutic Implications.2015,PLoS One 10(9):e0139001
> 15. Vernikos G, Medini D, Riley DR, Tettelin H. Ten years of pan-genome analyses. Curr Opin Microbiol. 2015 Feb;23:148-54. doi: 10.1016/j.mib.2014.11.016. Epub 2014 Dec 5. PMID: 25483351.
> 16. Dong, Rui & Zhu, Ziyue & Yin, Changchuan & He, Rong & Yau, S.s.-T. (2018). A new method to cluster genomes based on cumulative Fourier power spectrum. Gene. 673. 10.1016/j.gene.2018.06.042. 
> 17. Charrad, Malika & Ghazzali, Nadia & Boiteau, Véronique & Niknafs, Azam. (2014). NbClust: An R Package for Determining the Relevant Number of Clusters in a Data Set. Journal of Statistical Software. 61. 1-36. 10.18637/jss.v061.i06. 
> 18. Contreras-Moreira B, Vinuesa P. GET_HOMOLOGUES, a versatile software package for scalable and robust microbial pangenome analysis. Appl Environ Microbiol. 2013 Dec;79(24):7696-701. doi: 10.1128/AEM.02411-13. Epub 2013 Oct 4. PMID: 24096415; PMCID: PMC3837814.
> 19. Wang, H. ( 1 ) et al. (no date) ‘Metagenomic analysis of ssDNA viruses in surface seawater of Yangshan Deep-Water Harbor, Shanghai, China’, Marine Genomics, 41, pp. 50–53. doi: 10.1016/j.margen.2018.03.006.
> 20. Kim OTP, Kagaya Y, Tran HS, et al. A novel circular ssDNA virus of the phylumCressdnaviricotadiscovered in metagenomic data from otter clams (Lutraria rhynchaena). ARCHIVES OF VIROLOGY. 2020;165(12):2921-2926. doi:10.1007/s00705-020-04819-9
