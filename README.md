# Demo for roles and dynamic assignment of rights in Oracle APEX.

# APEX CONNECT 2020 - APEX-Autorisierung in der Praxis wartbar mit PL/SQL umsetzen

[Vortrag APEX Connect 2020 ](https://programm.doag.org/apex/2020/#/scheduledEvent/594982)

Jede Komponente in der Applikation schützen – wartbar und dynamisch – später vom Support einfach anpassbar

Oft ist zu Beginn eines Projekts noch nicht so recht klar wie später die Rollen und Rechte in der Applikation verteilt werden soll. Um das dann aber noch nachträglich sicher anzupassen, fehlt dann oft im Projekt am Ende die Kraft und das Budget.

Auch darf die Umsetzung von Sicherheits-Anforderungen die Entwicklung nicht zu stark durch zu viel Komplexität einschränken, die spätere Pflege und Wartung der Applikation muss verständlich bleiben und auch nach Fertigstellung des Projektes möglich sein.
Oracle APEX bietet zwar im Standard bereits ausreichend Optionen, die es dem Entwickler ermöglichen viele Anforderungen an den Zugriffschutz und die Sicherheit ohne große Einschränkungen bei der Entwicklung zu programmieren.

Aber am Ende muss das so dynamisch erfolgen, dass der Betrieb das auch selbständig anpassen kann.

Im Vortrag wird aufgezeigt, wie diese Aufgaben in der Praxis in einer zentralen Applikation für die Ausfall Erkennung von Kunden einer große Bankengruppen umgesetzt wurde und welche Möglichkeiten dazu APEX bietet.

Im Vortrag wird auf die folgenden Punkte eingegangen:
* Architektur APEX - Übersicht der Möglichkeiten der Autorisierung
* Wie die eingebauten Funktionen mit eigener Logik erweitert werden können.
  * Praxis Beispiel: mit PL/SQL für eigenes „Authorization Scheme“ in PL/SQL zum Filtern von APEX Items auf Basis von Stammdaten
* Architektur Ansätze, an welchen Stellen welche Features (Datenbank oder APEX) am besten im praktischen Einsatz angewendet werden können
* Apex Build Option für die Security einsetzen
