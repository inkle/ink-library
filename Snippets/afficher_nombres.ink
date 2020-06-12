/* ---------------------------------------------------------------------

  Afficher les nombres en français. Par défaut, les nombres sont ceux
  de France (soixante-dix, etc.) Il est possible d’utiliser les autres
  variantes de la francophonie en échangeant certaines lignes. Voir le
  corps de la fonction, plus bas.

  Cette fonction utilise les règles de l’orthographe modifiée de 1990,
  c’est-à-dire que tous les adjectifs numéraux sont séparés par des
  traits d’union.

--------------------------------------------------------------------- */

VAR pieces = 0
~ pieces = -42

Vous avez {afficher_nombre(pieces, true)} pièce{abs(pieces) > 1:s}.

=== function abs(x)
{x < 0:
    ~ return -x
- else:
    ~ return x
}

=== function afficher_nombre(x, g)
// g représente le genre: true pour féminin, false pour masculin
{
    - x < 0:
        moins {afficher_nombre(-x, g)}
    - x >= 2000:
        {afficher_nombre(x / 1000, false)}-mille{ x mod 1000 > 0:-{afficher_nombre(x mod 1000, g)}}
    - x >= 1000:
        mille{ x mod 1000 > 0:-{afficher_nombre(x mod 1000, g)}}
    - x >= 200:
        {afficher_nombre(x / 100, g)}-cent{x mod 100 == 0:s}{ x mod 100 > 0:-{afficher_nombre(x mod 100, g)}}
    - x >= 100:
        cent{ x mod 100 > 0:-{afficher_nombre(x mod 100, g)}}

    // Supprimer à partir d’ici pour utiliser les nombres hors de
    // France : septante, octante ou huitante, nonante.
    - x >= 80:
        quatre-vingt{ x mod 20 > 0:-{afficher_nombre(x mod 20, g)}}
    - x >= 72:
        soixante-{afficher_nombre(x % 20, g)}
    - x == 71:
        soixante-et-onze
    // Supprimer jusqu’ici pour septante, etc.

    - x == 0:
        zéro
    - else:
        { x >= 20:
            { x / 10:
                - 2: vingt
                - 3: trente
                - 4: quarante
                - 5: cinquante
                - 6: soixante
                // Remplacer ces lignes :
                - 7: soixante-dix
                - 8: quatre-vingt
                - 9: quatre-vingt-dix
                // Par celles-ci pour septante, etc.
                // - 7: septante
                // - 8: huitante // au choix
                // - 8: octante  // au choix
                // - 9: nonante
            }
            { x mod 10:
                - 0:
                - 1:
                <>-et-<>
                - else:
                <>-<>
            }
        }
        { x < 10 || x > 20:
            { x mod 10:
                - 1: {g:
                        une
                     - else:
                        un
                     }
                - 2: deux
                - 3: trois
                - 4: quatre
                - 5: cinq
                - 6: six
                - 7: sept
                - 8: huit
                - 9: neuf
            }
        - else:
            { x:
                - 10: dix
                - 11: onze
                - 12: douze
                - 13: treize
                - 14: quatorze
                - 15: quinze
                - 16: seize
                - 17: dix-sept
                - 18: dix-huit
                - 19: dix-neuf
            }
        }
}
