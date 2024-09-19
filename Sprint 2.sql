/**************************************************************************************************************************
Nivell 1

Exercici 1
A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

*/


/*Exercici 2
Utilitzant JOIN realitzaràs les següents consultes:

- Llistat dels països que estan fent compres.
- Des de quants països es realitzen les compres.
- Identifica la companyia amb la mitjana més gran de vendes.
*/

select distinct country països_que_estan_fent_compres from company
join transaction on transaction.company_id = company.id
where declined = 0;


select count(distinct country) quants_països_es_realitzen_les_compres from company
join transaction on transaction.company_id = company.id
where declined = 0;

select company.company_name companyia_amb_la_mitjana_més_gran_de_vendes from company
join transaction on transaction.company_id = company.id
where declined = 0
group by company.company_name
order by avg(amount) desc
limit 1;

/*Exercici 3
Utilitzant només subconsultes (sense utilitzar JOIN):

- Mostra totes les transaccions realitzades per empreses d'Alemanya.
- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
*/

select* from transaction
where declined=0 
and transaction.company_id in (select id from company where country='Germany');


select distinct company.company_name empreses_que_han_realitzat_transaccions_per_un_amount_superior_a_la_mitjana_de_totes_les_transaccions 
from company
where company.id in (
					select transaction.company_id from transaction
                    where declined = 0 and transaction.amount > (select avg(transaction.amount) from transaction)
                    );
                    

select distinct company.company_name empreses_que_no_tenen_transaccions_registrades 
from company
where company.id  not in (select transaction.company_id from transaction where declined =0);


/**************************************************************************************************************************
Nivell 2

Exercici 1
Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes.
*/

select date(timestamp) els_cinc_dies_que_es_va_generar_la_quantitat_més_gran_d_ingressos , sum(amount) ingresos from transaction
where declined = 0
group by date(timestamp)
order by sum(amount) desc 
limit 5;



/*Exercici 2
Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
*/

Select company.country país, round(avg(transaction.amount),2) mitjana_de_vendes
from company
join transaction on transaction.company_id=company.id
where declined = 0
group by company.country
order by mitjana_de_vendes DESC;

/*Exercici 3
En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries 
per a fer competència a la companyia "Non Institute".
Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país 
que aquesta companyia.

Mostra el llistat aplicant JOIN i subconsultes.
Mostra el llistat aplicant solament subconsultes.
*/

select * from transaction
join company on transaction.company_id=company.id
where company.country=(select country from company where company_name='Non Institute') and company_name!='Non Institute';




select*from transaction
where transaction.company_id in (
								select id from company 
                                where country=(select country from company where company_name='Non Institute')
                                );

/***************************************************************************************************************************
Nivell 3

Exercici 1
Presenta el nom, telèfon, país, data i amount, 
d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros 
i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. 
Ordena els resultats de major a menor quantitat.
*/

select company_name nom, phone telèfon, country país, date(timestamp) data, amount amount from company
join transaction on transaction.company_id=company.id 
where amount between 100 and 200 and date(timestamp) in ('2021-04-29', '2021-07-20', '2022-03-13')
order by amount desc;

/*Exercici 2
Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis 
si tenen més de 4 transaccions o menys.
*/

select company_name nom, count(*) quantitat_de_transaccions, if (count(*)>5, "si","no") mas_de_4  from company
join transaction on transaction.company_id=company.id
group by company_name;
