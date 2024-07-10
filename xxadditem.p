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

define variable     input_dir       as character                                            no-undo.
define variable     file_name       as character   initial "inputItem.csv"                  no-undo.
define variable     v_msg           as character                                            no-undo.
define variable     valid           as LOGICAL                                              no-undo.
define variable     confirmItem     as character   initial "Y"                              no-undo.

form   
    input_dir        colon 40   label "Import from"      format "x(50)" view-as fill-in size 40 by 1 
    file_name        colon 40   label "File name"        format "x(50)" view-as fill-in size 40 by 1 
with frame combinedframe side-labels width 100.

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

procedure get-dir-path: 
 
   define input  parameter ip-dir  as character no-undo.
   define output parameter op-path as character no-undo.
 
   if ip-dir <> "" then do:             
      if substring(ip-dir, length(ip-dir)) = "/"
      then op-path = ip-dir.
      else op-path = ip-dir + "/".
   end.                                 
 
end procedure. 

procedure check_directory:

   define input  parameter i-dir    as character no-undo.
   define input  parameter i-rights as character no-undo.
   define output parameter o-msg    as character no-undo.
 
   o-msg = "".
   file-info:file-name = i-dir.
   if file-info:file-type = ? or not (file-info:file-type matches i-rights) then do:
      o-msg =  i-dir + " : does not exist or is not accessible".           
   end.
 
end procedure.

procedure check_file:

   define input  parameter i-dir    as character no-undo.
   define input  parameter i-file   as character no-undo.
   define input  parameter i-rights as character no-undo.
   define output parameter o-msg    as character no-undo.
 
   o-msg = "".
   file-info:file-name = i-dir + i-file.
   if file-info:file-type = ? or not index(file-info:file-type, i-rights) > 0 then do:
      o-msg =  i-dir + i-file +  " : does not exist or is not accessible. " .           
   end.
 
end procedure.

procedure empty:
    define input  parameter ip_item            as rowid.
    define output parameter allFieldsFilled    as logical initial true no-undo.
    
    find tt_item where rowid(tt_item) = ip_item no-lock no-error.
    if not available tt_item then return.

    if tt_item.domainItem = "" then do:
        message "Domain is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    if tt_item.numItem = "" then do:
        message "Item Number is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    if tt_item.prodLine = "" then do:
        message "Prod Line is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    if tt_item.typeItem = "" then do:
        message "Item Type is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    if tt_item.statusItem = "" then do:
        message "Status is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
    if tt_item.pur_manItem = "" then do:
        message "Purchase/Manufacture is required." view-as ALERT-BOX ERROR.
        allFieldsFilled = false.
    end.
end procedure.

procedure verification:
        define input  parameter ip_item            as rowid.
        define output parameter valid              as logical initial true no-undo.
        find tt_item where rowid(tt_item) = ip_item no-lock no-error.
        if not available tt_item then return.
        find first pt_mstr  where pt_part = numItem         no-lock no-error.
        find first pl_mstr  where pl_prod_line = prodLine   no-lock no-error.
        find first qad_wkfl where qad_key2 = statusItem     no-lock no-error.

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
procedure filltable:
input from value(input_dir + file_name).
                repeat:

                    create tt_item.
                    import delimiter "|" tt_item.
                end.
                input close.
end procedure.
input_dir = session:temp-directory.
mainloop:
repeat:
    empty temp-table tt_item.
    update
        input_dir
        file_name
    with frame combinedframe.

    run get-dir-path(input input_dir,
                     output input_dir).

    v_msg = "".
   run check_directory (input input_dir,
                     input "D*W",
                     output v_msg).

   if v_msg <> "" then
        MESSAGE v_msg VIEW-AS ALERT-BOX.
   else do :
          run check_file (  input input_dir,
                            input file_name,
                            input "R",
                            output v_msg).

          if v_msg <> "" then
            MESSAGE v_msg VIEW-AS ALERT-BOX.  
          else do :
                run filltable.
                    for each tt_item:
                        run empty(input rowid(tt_item),output valid).
                        if not valid then next.
                        run verification(input rowid(tt_item),output valid).
                        if not valid then next.
                        else do:
                            display tt_item.
                            end.    
                    end.
                end.
        end.                
end.

