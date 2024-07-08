/************************************************************************/
/* nomprog       : zzadditem.p                                          */
/* Module        :                                                      */
/* But           : input and add new item details to the database.      */
/* Prog. origine :                                                      */
/* Appele par    :                                                      */
/* run           :                                                      */
/*                                                                      */
/* Include       :                                                      */
/*                                                                      */
/*----------------------------------------------------------------------*/ 
/* Num modif     !Auteur! Date     ! Commentaires                       */ 
/*---------------!------!----------!------------------------------------*/ 
/*               !      !          |                                    */ 
/*======================================================================*/ 

define variable     numItem         as character                                            no-undo. /* pt_mstr.pt_part */
define variable     descItem        as character   initial "new item added from putty"      no-undo. /* pt_mstr.pt_desc1 */
define variable     prodLine        as character   initial "Def"                            no-undo. /* pt_mstr.pt_prod_line */
define variable     addedDate       as DATE        initial today                              no-undo. /* pt_mstr.pt_added */
define variable     typeItem        as character   initial "BB"                             no-undo. /* pt_mstr.pt_part_type */
define variable     statusItem      as character   initial "ACTIF"                          no-undo. /* pt_mstr.pt_status */
define variable     pur_manItem     as character   initial "P"                              no-undo. /* pt_mstr.pt_pm_code */
define variable     priceItem       as decimal     initial 0                                no-undo. /* pt_mstr.pt_price */

form
    
    "Item"                  colon 35                                        view-as text size 40 by 1
    skip(1)
    numItem                 colon 40   label "Item Number"                  format "x(15)" view-as fill-in size 15 by 1
    descItem                colon 40   label "Description"                  format "x(30)" view-as fill-in size 30 by 1
    skip(1)
    "Item Data"             colon 35                                        view-as text size 40 by 1
    skip(1)
    prodLine                colon 40   label "Prod Line"                    format "x(10)" view-as fill-in size 10 by 1
    addedDate               colon 40   label "Added"                        format "99/99/9999" view-as fill-in size 13 by 1
    typeItem                colon 40   label "Item Type"                    format "x(10)" view-as fill-in size 10 by 1
    statusItem              colon 40   label "Status"                       format "x(10)" view-as fill-in size 10 by 1
    skip(1)
    "Item Planning Data"    colon 35                                        view-as text size 40 by 1
    skip(1)
    pur_manItem             colon 40   label "Purchase/Manufacture"         format "x(1)"  view-as fill-in size 1 by 1
    skip(1)
    "Item Price Data"       colon 35                                        view-as text size 40 by 1
    skip(1)
    priceItem               colon 40   label "Price"                         format "->,>>>,>>9.99" view-as fill-in size 15 by 1  
    skip(1)
with frame combinedframe side-labels width 100.


mainloop:
    repeat:
        update
            numItem
            descItem 
            prodLine
            addedDate
            typeItem
            statusItem
            pur_manItem
            priceItem
        with frame combinedframe.
    end. 



