// Hexa-automaton by Vanlindt Marc (www.vanlindt.be) (c) 2016 - GNU GPL v3 (https://www.gnu.org/licenses/gpl-3.0.fr.html)
// 1. Variables
// 1.1. Variables modifiables 
// 1.1.1 Taille de l'écran
// 1.1.2 Remplissage du monde
// 1.1.3 Captures des images
// 1.1.4 Informations Monde
// 1.1.5 Variables non modifiables
// 2. setup
// 3. draw
// 4. TailleEcran
// 5. CreaMonde (se trouve à la fin vu le nombre de lignes)
// 6. SauveCaptures
// 7. Affichage
// 8. Utilisation clavier
//
// 1. Variables
// 1.1. Variables modifiables 
// 1.1.1 Taille de l'écran
// TailleEcranFixe : 0 ou 1. Si à 0, la taille de l'écran sera calculée en fonction du nombre de Colonnes, de Rangées, et de la taille des Cellules
// DefLargeur : Indique la largeur, en pixels, de l'écran si TailleEcranFixe est activé.
// DefHauteur : Indique la hauteur, en pixels, de l'écran si TailleEcranFixe est activé.

    int TailleEcranFixe = 0;
    int DefLargeur = 1920;
    int DefHauteur = 1080;

// 1.1.2 Remplissage du monde
// MondeAleatoire : Si à 0, la cellule centrale sera vivante et toutes les autres mortes 
// Si à 1, le monde sera rempli de manière aléatoire de cellules vivantes.
// Si à 2, le monde comprend une petite forme de cellules vivantes en son centre
// Densite : Indique la densité de population du monde avec un rapport de 1/Densite.

    int MondeAleatoire=1;
    int Densite = 30;

// 1.1.3 Captures des images
// EnregistremantCaptures : 0 ou 1. Si à 1, chaque génération sera capturée au format PNG
// DossierCaptures : Indique le sous-dossier dans lesquelles seront sauvées le captures.
// NomCaptures : Indique le nom de fichier qu'auront les captures. Les captures prendront ce nom suivi du numéro de génération

    int EnregistrementCaptures = 0;
    String DossierCaptures = "Captures4";
    String NomCaptures = "Captures";

// 1.1.4 Informations Monde
// Colonnes : Indique le nombre de colonnes utilisées pour générer le monde.
// Rangees : Indique le nombre de rangées utilisées pour générer le monde.
// TailleCellule : Indique le diamètre en pixels des cellules.
// Vitesse : Effectue une pause, exprimée en ms, entre chaque génération
// Croissance : Durée de la croissance d'une cellule
// DureeVie : Durée de vie d'une cellule "adulte".
// ConditionsVie : Indique les conditions à la naissance d'une cellule.
// Il est composé de 7 chiffres (0 ou 1).
// Ces chiffres correspondent aux 7 états possibles que peut avoir une cellule, de 0 cellules vivantes autour d'elle à 6 cellules vivantes l'entourant.
// Donc, par exemple, {0,1,0,1,0,0,1} signifie : 
// S'il y a 0 cellules vivantes alors 0 = rester morte.
// S'il y a 1 cellules vivantes alors 1 = naître.
// S'il y a 2 cellules vivantes alors 0 = rester morte.
// S'il y a 3 cellules vivantes alors 1 = naître.
// S'il y a 4 cellules vivantes alors 0 = rester morte.
// S'il y a 5 cellules vivantes alors 0 = rester morte.
// S'il y a 6 cellules vivantes alors 1 = naître.
    
    int Colonnes =120;
    int Rangees = 70;
    int TailleCellule = 8;
    int Vitesse=000;
    int Croissance = 32;
    int DureeVie = 0;
    int[] ConditionsVie = {0,0,1,1,1,0,1}; 

// 1.1.5 Variables non modifiables
// compteur : Compteur général permettant de savoir à quelle génération nous sommes.
// Monde : Créer le monde où iront les cellules
// Entourage : Créer la zone d'analyse d'entourage
// 
    
    int compteur = 0; 
    int[][][] Monde;
    int[][] Entourage; 

// 2. setup

    void setup()
    {
        strokeWeight(0); // Fait en sorte qu'il n'y ait jamais de rebors aux cercles.
        size(1920,1080, P2D);
        TailleEcran(); // Définit la taille de l'écran
        CreaMonde(); // Créer le monde et y place les cellules vivantes de base
    }

// 3. draw

    void draw()
    {
        background(0); // Fond en noir

        Affichage(); // Effectue les calculs et affiche les cellules vivantes ou non
        delay(Vitesse); // Indique le temps de pause entre chaque génération
        SauveCaptures(); // Effectue une capture d'image 
        compteur=compteur+1; // Incrémente le compteur général
    }

// 4. TailleEcran

    void TailleEcran()
    {
        if (TailleEcranFixe == 0)
        // Si la taille d'écran n'est pas fixe
        {
//            size((Colonnes/2*TailleCellule)+(Colonnes/2*(TailleCellule*66/100)),Rangees*TailleCellule, P2D);
            // Il calcule la taille en fonction du nombre de colonnes et de rangées
            // Vu que les colonnes n'ont pas toutes la même taille et qu'une sur deux a une taille réduite, la largeur d'écran est calculée
            // en essayant d'en tenir compte. Une moitié du nombre de colonnes est donc multipliée par la taille d'une cellule et l'autre moitié
            // est multipliée par la taille d'une cellule réduite de 2/3.
        }
        else
        {
            size(DefLargeur,DefHauteur, P2D);
            // Et si elle est fixe, elle prend la taille définie par les variables.
        } 
    }

// 5. CreaMonde

void CreaMonde()
{
Monde = new int[Rangees][Colonnes][2];
// Le monde prend une taille correspondant au nombre de rangées et de colonnes.
// Il est créé en deux exemplaires, le premier étant "l'état actuel", le second "l'étant en devenir".
// Il faut passer par deux tableaux car si l'on passe par un seul, l'analyse d'une cellule prendra en compte les changements effectués aux 
// cellules précédentes.
Entourage = new int[6][2];
// Il génère les possibilités d'entourage 
// Il indique que la cellule au centre de l'écran est vivante.
if (MondeAleatoire == 0)
{
Monde[Rangees/2][Colonnes/2][0]=1;
}
if (MondeAleatoire == 1)
// Si choix de monde aléatoire
{
for (float i = 1; i<Rangees; i++) 
{
for (float j = 1; j<Colonnes; j++) 
{
// Parcourt toutes les cellules 
int r = int(random(Densite));
// Génère un nombre aléatoire en fonction de la densité voulue
if (r==1)
// Si ce nombre aléatoire est sorti
{
Monde[int(i)][int(j)][0]=1;
// alors il créé une cellule vivante.
}
}
}
} 
if (MondeAleatoire == 2)
// Si choix de monde aléatoire
{
Monde[Rangees/2+0][Colonnes/2+1][0]=1;
Monde[Rangees/2+0][Colonnes/2+2][0]=1;
Monde[Rangees/2+0][Colonnes/2][0]=1;
Monde[Rangees/2+0][Colonnes/2-1][0]=1;
Monde[Rangees/2+0][Colonnes/2-2][0]=1;
Monde[Rangees/2+2][Colonnes/2][0]=1;
Monde[Rangees/2+1][Colonnes/2][0]=1;
Monde[Rangees/2-1][Colonnes/2][0]=1;
Monde[Rangees/2-2][Colonnes/2][0]=1;
}
}
// 6. SauveCaptures
void SauveCaptures()
{
String zeros = "";
if (EnregistrementCaptures == 1) 
{ 
if (compteur < 1000000) {zeros = "0"; }
if (compteur < 100000) {zeros = "00"; }
if (compteur < 10000) {zeros = "000"; }
if (compteur < 1000) {zeros = "0000"; }
if (compteur < 100) {zeros = "00000"; }
if (compteur < 10) {zeros = "000000"; } 
save(""+DossierCaptures+"/"+NomCaptures+zeros+compteur+".png");
// Créé une capture d'écran.
// Il ajoute automatiquement des 0 entre le nom de fichier voulu et le nombre de génération afin de ne pas poser 
// de problème à l'importation d'un logiciel traitant voxels, pack d'images, etc.
}
}
// 7. Affichages
void Affichage()
{
float modifhauteur;
// génère une variable permettant de modifier la hauteur des cellules en fonction de leur colonne. 
for (float i = 1; i<Rangees; i++) 
{
for (float j = 1; j<Colonnes; j++) 
{
// parcourt toutes les cellules
if (j/2==round(j/2)) {modifhauteur=0;}else{modifhauteur =TailleCellule/2;}
// Selon que la colonne soit paire ou impaire il indique s'il doit modifier la hauteur des cellules ou non.
fill(Monde[int(i)][int(j)][0]*(255/Croissance),Monde[int(i)][int(j)][0]*(255/Croissance),Monde[int(i)][int(j)][0]*(255/Croissance));
// Il indique en quelle niveau de dégradé doit être la cellule en fonction de son stade de croissance ou de sa durée de vie.
ellipse (TailleCellule*86/100*j,modifhauteur+(TailleCellule*i),TailleCellule,TailleCellule); 
// Affiche la cellule 
}
}
for (float i = 2; i<Rangees-1; i++) 
{
for (float j = 2; j<Colonnes-1; j++) 
{
// Parcourt le monde
if (Monde[int(i)][int(j)][1] >=Croissance+DureeVie ){Monde[int(i)][int(j)][1]=0;}
// si une cellule est tout à la fin de sa vie, elle meurt
if ((j/2)!=round(j/2)){modifhauteur=+1;}else{modifhauteur=-1;}
// Vérifie dans quelle colonne il est pour calculer l'entourage
if (Monde[int(i)][int(j-1)][0]==-1){Entourage[0][0]=Croissance;}else{Entourage[0][0] = Monde[int(i)][int(j-1)][0];}
if (Monde[int(i-1)][int(j)][0]==-1){Entourage[1][0]=Croissance;}else{Entourage[1][0] = Monde[int(i-1)][int(j)][0];}
if (Monde[int(i)][int(j+1)][0]==-1){Entourage[2][0]=Croissance;}else{Entourage[2][0] = Monde[int(i)][int(j+1)][0];}
if (Monde[int(i+modifhauteur)][int(j+1)][0]==-1){Entourage[3][0]=Croissance;}else{Entourage[3][0] = Monde[int(i+modifhauteur)][int(j+1)][0];}
if (Monde[int(i+1)][int(j)][0]==-1){Entourage[4][0]=Croissance;}else{Entourage[4][0] = Monde[int(i+1)][int(j)][0];}
if (Monde[int(i+modifhauteur)][int(j-1)][0]==-1){Entourage[5][0]=Croissance;}else{Entourage[5][0] = Monde[int(i+modifhauteur)][int(j-1)][0];}
// Chaque valeur des cellules environnantes est sauvegardée.
for (int z =0;z<6;z++)
{
if (Entourage[z][0]==0){Entourage[z][1]=0;}else{Entourage[z][1]=1;}
// Dans un second tableau, il indique s'il est en présence d'une cellule morte ou en cours de vie.
// Contrairement au premier tableau où un nombre indique à quel niveau de dégradé il est, le second n'indiquera
// que 0 ou 1, si la cellule est morte ou vivante. 
}
int vartotal = Entourage[0][1]+Entourage[1][1]+Entourage[2][1]+Entourage[3][1]+Entourage[4][1]+Entourage[5][1];
// une variable est créée afin de connaître le total de cellules vivantes dans l'entourage
if (Monde[int(i)][int(j)][1]==0)
// Si la cellule est morte
{ 
for (int z = 0; z<7;z++)
{
if (vartotal == z) {Monde[int(i)][int(j)][1] = ConditionsVie[z];}
// Pour chacun des états possible, il va voir dans les conditions de vie si la cellule doit naître ou rester morte.
}
}
else 
{
Monde[int(i)][int(j)][1]=Monde[int(i)][int(j)][1]+1;
// Si la cellule est vivante, elle augmente sa croissance. 
}
if (Monde[int(i)][int(j)][0]==-1)
// Si la cellule est inactive
{
Monde[int(i)][int(j)][1]=-1; 
} 
}
} 
for (float i = 1; i<Rangees; i++) 
{
for (float j = 1; j<Colonnes; j++) 
{
Monde[int(i)][int(j)][0] = Monde[int(i)][int(j)][1];
// Le second monde, celui de calcul, devient le premier, celui affiché.
}
}
}
// 8. Utilisation clavier
void keyPressed() {
if (key == '+') {Vitesse=Vitesse+50;}
if (key == '-') {if (Vitesse==0) {Vitesse=0;} else {Vitesse=Vitesse-50;}}
if (key == '0') {if (ConditionsVie[0]==0) {ConditionsVie[0]=1;} else {ConditionsVie[0]=0;}}
if (key == '1') {if (ConditionsVie[1]==0) {ConditionsVie[1]=1;} else {ConditionsVie[1]=0;}}
if (key == '2') {if (ConditionsVie[2]==0) {ConditionsVie[2]=1;} else {ConditionsVie[2]=0;}}
if (key == '3') {if (ConditionsVie[3]==0) {ConditionsVie[3]=1;} else {ConditionsVie[3]=0;}}
if (key == '4') {if (ConditionsVie[4]==0) {ConditionsVie[4]=1;} else {ConditionsVie[4]=0;}}
if (key == '5') {if (ConditionsVie[5]==0) {ConditionsVie[5]=1;} else {ConditionsVie[5]=0;}}
if (key == '6') {if (ConditionsVie[6]==0) {ConditionsVie[6]=1;} else {ConditionsVie[6]=0;}}
if (key == '/') {if (Croissance==1) {Croissance=1;} else {Croissance=Croissance-1;}}
if (key == '*') {Croissance=Croissance+1;}
if (key == '.') {Monde = new int[Rangees][Colonnes][2];CreaMonde();}
if (key == 'i') {
println("00 | 01 | 02 | 03 | 04 | 05 | 06");
println(ConditionsVie[0]+" | "+ConditionsVie[1]+" | "+ConditionsVie[2]+" | "+ConditionsVie[3]+" | "+ConditionsVie[4]+" | "+ConditionsVie[5]+" | "+ConditionsVie[6]);
println("Compteur : "+compteur);
}
println("00 | 01 | 02 | 03 | 04 | 05 | 06");
println(ConditionsVie[0]+" | "+ConditionsVie[1]+" | "+ConditionsVie[2]+" | "+ConditionsVie[3]+" | "+ConditionsVie[4]+" | "+ConditionsVie[5]+" | "+ConditionsVie[6]);
}