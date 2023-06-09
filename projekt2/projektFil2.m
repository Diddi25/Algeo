%--------------------------------------------------------------------------
% IX1303-VT2023: PROJEKTUPPGIFT 2, CO2 mätning
%
% Detta är en template.
% Ni ska fylla i koden som efterfrågas och svara på frågorna.
% Notera att alla svar på frågor måste skrivas på raden som börjar med "%".
%--------------------------------------------------------------------------

clear all

%----- SKRIV KOD: Fyll i data-filens namn (ta med .csv, .txt, eller liknande) -----
filename="monthly_in_situ_co2_mlo.csv";
TABLE=readtable(filename);

%----- SKRIV KOD: Fyll i namnen på de kolumner som innehåller tid och data (dvs byt ut XXXXXX) -----
% Namnen på dessa kolumner finns oftast i csv filen. Men, om ni har
% läst in tabellen TABLE kan du se listan av kolumner genom att skriva 
% "T.Properties.VariableNames" i kommand-prompten. 
% Notera att när man arbetar med data någon annan skapat krävs ofta lite
% detektivarbete för att förstå exakt vad alla värden beskriver!

T = [ TABLE.Date_1(79:787)];  % T ska vara en vektor med tiden för olika C02 mätningar
y = [ TABLE.CO2(79:787)];  % y ska vara en vektor med data från CO2 mätningar

%The variables above are in a specific range by the reason of exceptional
%data points outside the range that impacts the adjusting curves.

%----- SKRIV KOD: Skapa en minstakvadrat anpassning av y(t) till en rät linje -----
% Initialize an empty vector
onlyOnesVector = [];

% Loop to add element 1 in empty vector
for i = 1:length(T)
 
    newElement = 1;
    
    onlyOnesVector(i, 1) = newElement;

end

newMatrix = [T, onlyOnesVector]; %concatenate both vectors

coefficients1 = mldivide(newMatrix, y); %solve TX2 matrix

%solving for constants for y = kx + m from the matrix x
k = coefficients1(1); 
m = coefficients1(2);

y1 = k*T + m; % new adjusted linear functon

%----- SKRIV KOD: Rita både mätdata och anpassningen i samma graf. -----
plot(T, y, T, y1);
axis([1962, 2025, 312, 430]);
title('Keeling Curve and Fitted Linear Curve')
grid on;
figure; hold on;

%----- SKRIV KOD: Skapa en minstakvadrat anpassning av y(t) till ett andragradspolynom -----
% Construct the coefficient matrix
X2 = [T.^2, T, ones(size(T))];

coefficients2 = X2 \ y;

a2 = coefficients2(1);
b2 = coefficients2(2);
c2 = coefficients2(3);

y2 = a2 * T.^2 + b2 * T + c2;

%----- SKRIV KOD: Rita både mätdata och anpassningen i samma graf. -----

plot(T, y, T, y2);
axis([1962, 2025, 312, 430]);
title('Keeling Curve and Fitted Quadratic Curve');
grid on;
figure; hold on;

%----- SKRIV KOD: Skapa en minstakvadrat anpassning av y(t) till ett tredjegradspolynom -----
% Construct the coefficient matrix
X3 = [T.^3, T.^2, T, ones(size(T))];

coefficients3 = X3 \ y;

a3 = coefficients3(1);
b3 = coefficients3(2);
c3 = coefficients3(3);
d3 = coefficients3(4);

y3 = a3 * T.^3 + b3 * T.^2 + c3 * T + d3;

%----- SKRIV KOD: Rita både mätdata och anpassningen i samma graf. -----
plot(T, y, T, y3);
axis([1962, 2025, 312, 430]);
grid on;
title('Keeling Curve and Fitted Cubic Curve');

% Frågor:
% 1. Beskriv med egna ord hur de tre kurvorna beskriver. Framför allt, blir lösningen lite eller mycket bättre när vi går från en rät linje till en andragradsfunktion? Blir den mycket bättre när vi går från en andragradsfunktion till en tredjegradsfunktion?
% SVAR: ...
% Anpassningarna blir mycket bättre när anpassningen går från linjär till
% en andragradsfunktion. Detta har att göra med att den tillgängliga datan
% följer en andragradskurva bättre än den linjära. Så det blir mycket
% bättre. Till utseendet blir övergången från andragradskurvan till
% tredjegradskurvan inte signifikant mycket bättre jämfört med övergången
% från en linjär till kvadratisk anpassning. Men detta kan ha att göra med
% att det inte finns tillräcklig mycket tillgänglig data för att jämföras
% med. 

% 2. Kan man använda dessa anpassningar för att uppskatta utsläppen om 2 år? Motivera ditt svar.
% SVAR: ...
% Det kan man eftersom det ligger nära till tiden som datat är från, dvs
% den senaste datan är från nutid. Men även att den tillgängliga datan är
% tillräcklig stor för att förutspå hur det kommer bli om 2 år. 

% 3. Kan man använda dessa anpassningar för att uppskatta utsläppen om 50 år? Motivera ditt svar.
% SVAR: ...
% Den kan användas om 50 år, men å andra sidan följer inte alla typer av
% exponentiella utvecklingstrender en fortsatt exponentiell tillväxt.
% Detta eftersom sådana utvecklingar kan smalna av efter en period av
% exponentiell utveckling då det mer liknar en S-kurva. (Det har med typen 
% av datat också att göra) Vilket i det fallet en kurva av högre grad än 
% två skulle vara aktuell. Det finns exempelvis faktorer som att länder 
% övergår mer till förnybara bränslen och förbrukar energi mer effektivt 
% än vad man gör idag. Men om dessa förändringar inte görs kan 
% anpassningarna stämma om 50 år. 


