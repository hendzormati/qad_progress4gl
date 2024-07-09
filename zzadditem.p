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
define variable     addedDate       as DATE        initial today                            no-undo. /* pt_mstr.pt_added */
define variable     typeItem        as character   initial "BB"                             no-undo. /* pt_mstr.pt_part_type */
define variable     statusItem      as character   initial "ACTif"                          no-undo. /* pt_mstr.pt_status */
define variable     pur_manItem     as character   initial "P"                              no-undo. /* pt_mstr.pt_pm_code */
define variable     priceItem       as decimal     initial 0                                no-undo. /* pt_mstr.pt_price */
define variable     valid           as LOGICAL                                              no-undo.
define variable     confirmItem     as character   initial "Y"                              no-undo.

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

form 
    confirmItem             colon 40   label "Confirm the add of this item (Y/N)"         format "x(1)"  view-as fill-in size 1 by 1
 with frame confirmframe side-labels width 100.   

define frame displayitemframe
    "Item Details verification" colon 35                                            view-as text size 40 by 1
    skip(1)
    numItem                     colon 40   label "Item Number"                      view-as text size 40 by 1
    descItem                    colon 40   label "Description"                      view-as text size 40 by 1
    prodLine                    colon 40   label "Prod Line"                        view-as text size 40 by 1
    addedDate                   colon 40   label "Added"                            view-as text size 40 by 1
    typeItem                    colon 40   label "Item Type"                        view-as text size 40 by 1
    statusItem                  colon 40   label "Status"                           view-as text size 40 by 1
    pur_manItem                 colon 40   label "Purchase/Manufacture"             view-as text size 40 by 1
    priceItem                   colon 40   label "Price"                            view-as text size 40 by 1 
    skip(1)
with side-labels width 100.
procedure empty:
   define output parameter allFieldsFilled    as logical initial true no-undo.
    if numItem = "" then do:
        message "Item Number is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    else if prodLine = "" then do:
        message "Prod Line is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    else if typeItem = "" then do:
        message "Item Type is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    else if statusItem = "" then do:
        message "Status is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    else if pur_manItem = "" then do:
        message "Purchase/Manufacture is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
end procedure.
procedure verification:
   define output parameter valid    as logical initial true no-undo.

    find first pt_mstr where pt_part = numItem no-lock no-error.
    find first pl_mstr where pl_prod_line = prodLine no-lock no-error.
    find first qad_wkfl where qad_key2 = statusItem no-lock no-error.

    if  available pt_mstr then do:
        message "Item already exist." view-as ALERT-BOX ERROR.
        valid=false.
    end. 
    else if not  available pl_mstr then do:
        message "Prod Line doesn't exist." view-as ALERT-BOX ERROR.
        valid=false.
    end. 
    else if not  available qad_wkfl then do:
        message "Status doesn't exist." view-as ALERT-BOX ERROR.
        valid=false.
    end. 
    
end procedure.
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
        hide FRAME combinedframe.
        run empty(output valid).
        if not valid then next.
        run verification(output valid).
        if not valid then next.
        display
            numItem
            descItem 
            prodLine
            addedDate
            typeItem
            statusItem
            pur_manItem
            priceItem
        with frame displayitemframe.
        update
            confirmItem
        with frame confirmframe.
        hide frame displayitemframe.
        hide frame confirmframe.
    end. 



