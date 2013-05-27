Proposal

Een app die dynamisch de trekkracht berekend, afhankelijk van het materiaal en de hoek. De app heeft 3 verschillende input waardes, en weergeeft dynamisch 2 outputs.

Input variabelen:
- De load: Statisch of rollend.
- Gewicht van de load
- De ondergrond

Output:
- Berekening van de hoek en weergave
- Capacity used (trekkracht)

De app zal de laatst gebruikte input onthouden, omdat in praktijk de app vaak op dezelfde ondergrond achter mekaar zal worden gebruikt.

De keuze bij a beinvloed het scherm. Bij ‘static’ horen namelijk andere waardes bij d dan bij ‘rolling’. Dus deze keuze laat het scherm wisselen, van links naar rechts en terug.

Bij b kan men het gewicht handmatig invoeren.

d veranderd aan de hand van ‘static’ of ‘rolling’. Dit zijn radio buttons die blijven staan op de laatste input.

De hoek berekening (e) gaat met behulp van de accelerometer die ingebouwd is in de iPhone. De hoek zal worden weergeven in aantal graden en in % grade (f) (dit is een andere maatstaf voor de hoek). Zodra we de app gaan designen zal duidelijk worden of we deze 2 waardes (graden en grade) tegelijk op het scherm laten zien of dat je hier tussen kan kiezen.

Bij de input waardes ‘gewicht van de load’ en output ‘capacity used’ zal men de keuze kunnen maken met behulp van een button of het gewicht wordt weergeven in aantal kilogram of ponden (kg of lbs).
Op de schets van de app staan er 2 van deze buttons (c en h). Het is waarschijnlijk beter design om hier 1 knopje voor te maken, zodat de gebruiker dit eenmalig hoeft te kiezen. 

De uiteindelijke output (en doel van de app) bij g. Alle voorgaande waardes (de 3 input variabele en de hoek berekening) worden meegenomen in een berekening, om hier uiteindelijk de kracht te weergeven.

Design document

a.
UISengementedControl. Heeft 2 buttons, static en rolling. Iedere waarde wordt gekoppeld aan 1 scherm via de Interface Builder (drag drop). Ieder scherm heeft verschillende waardes bij d, voor de rest is de code hetzelfde (behalve dat de berekening dus veranderd wordt door de verschillende waardes bij d)

b.
UITextField. Een normaal text input field, wat nu alleen gebruikt kan worden voor getallen input. Deze waarde zal exact ook weer als output mee worden gegeven aan de berekening.

c en h. 
Hier zullen we dus waarschijnlijk 1 button van maken. Een UISwitch. Door middel van de switch ‘om te zetten’ kan je wisselen tussen kg of lbs voor de gehele berekening en weergave. 

d.
Hier is de keuze voor welke ondergrond. Dit veranderd aan de hand van de keuze bij a. We dachten om een radio button menu te maken met losse UIButton’s.. Dit zit alleen niet standaard in de IDE. 
Andere optie is om een UISegmentedControl te gebruiken. En dan een click event hieraan te koppelen met UIControl (dt is Segmentedcontrols parent class). Dan de output van UIControl mee te nemen in de berekening.

e.
Een non-editable text field, met hierin weergeven de hoek waarde. Deze waarde wordt meegenomen in de verdere berekening.

f.
Een non-editable text field, met hierin weergeven de grade waarde.

g.
Een non-editable text field, met hierin weergeven de capacity load.


De accelerometer
Op het moment van schrijven van dit document weten we nog niet exact hoe de accelerometer geimplementeerd moet worden. Wel weten we al dat er vele toturials en open source code beschikbaar is.
