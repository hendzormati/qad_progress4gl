/************************************************************************/
/* nomprog       : xxadditem.p                                          */
/* Module        :                                                      */
/* But           : add items to the database from an csv file.           */
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

define variable     output_dir      as character                                            no-undo.
define variable     file-name       as character                                            no-undo.
define variable     valid           as LOGICAL                                              no-undo.
define variable     confirmItem     as character   initial "Y"                              no-undo.

define temp-table tt_item no-undo
    field  domainItem       like    pt_domain
    field  numItem          like    pt_part 
    field  descItem         like    pt_desc1
    field  prodLine         like    pt_prod_line
    field  addedDate        like    pt_added
    field  typeItem         like    pt_part_type
    field  statusItem       like    pt_status
    field  pur_manItem      like    pt_pm_code
    field  priceItem        like    pt_price.
output_dir = session:temp-directory.
file-name = "item__17032024.csv".
INPUT FROM VALUE(output_dir + file-name).

REPEAT:

    create tt_item.

    import delimiter "|" tt_item.

END.

input close.

 

for each tt_item.

display tt_item.

end.
