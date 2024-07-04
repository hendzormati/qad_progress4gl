/************************************************************************/
/* nomprog       : zzitemmaintenance.p                                  */
/* Module        :                                                      */
/* But           : item range display and export to csv file            */
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


define variable     numItemStart    as character    initial "0001"            no-undo.
define variable     numItemEnd      as character    initial "0008"            no-undo.
define variable     output_dir      as character                              no-undo.

define variable     totalStandard   as decimal                                no-undo.
define variable     totalCurrent    as decimal                                no-undo.

define variable     v_msg           as character                              no-undo.
define variable     file-name       as character                              no-undo.
define variable     export-success  as LOGICAL                                no-undo.
define variable     dt              as DATETIME    initial now                no-undo.



define temp-table tt_item
    field  tt_ItemCode      like    pt_part
    field  tt_Libelle       like    pt_desc1 
    field  tt_Price         like    pt_price
    field  tt_Cost_Standard as      decimal
    field  tt_Cost_Current  as      decimal.

form
    numItemStart     colon 40   label "Item Number"    format "x(30)" view-as fill-in size 15 by 1
    numItemEnd       colon 40   label "To"             format "x(30)" view-as fill-in size 15 by 1
    skip(1)
    output_dir       colon 56   label "Export To"      format "x(50)" view-as fill-in size 40 by 1 
with frame combinedframe side-labels width 100.

define frame itemDetailsframe
    tt_ItemCode       label "Item Number"
    tt_Libelle        label "Description"
    tt_Price          label "Item Price"
    tt_Cost_Standard  label "Cost Std"
    tt_Cost_Current   label "Cost Crt".

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


output_dir = session:temp-directory.

mainloop:

repeat:
    
    empty temp-table tt_item.

    update
        numItemStart
        numItemEnd 
        output_dir
    with frame combinedframe.

    find first pt_mstr where pt_part = numItemStart no-lock no-error.

    if not available pt_mstr then do:
        message "Item Number Start doesn't exist." view-as ALERT-BOX ERROR.
        next.
    end. 

    find first pt_mstr where pt_part = numItemEnd no-lock no-error.

    if not available pt_mstr then do:
        message "Item Number End doesn't exist." view-as ALERT-BOX ERROR.
         next.
    end. 
    
    run get-dir-path(input output_dir,
                     output output_dir).
    v_msg = "".
   run check_directory (input output_dir,
                     input "D*W",
                     output v_msg).
   if v_msg <> "" then
        MESSAGE v_msg VIEW-AS ALERT-BOX.
    ELSE do:

        FOR EACH pt_mstr WHERE pt_mstr.pt_part >= numItemStart AND pt_mstr.pt_part <= numItemEnd NO-LOCK:

            FOR EACH sct_det WHERE sct_det.sct_part = pt_mstr.pt_part AND sct_det.sct_site = pt_mstr.pt_site NO-LOCK:
                IF sct_det.sct_sim = "Standard" THEN totalStandard = sct_cst_tot.
                ELSE IF sct_det.sct_sim = "Current" THEN totalCurrent = sct_cst_tot.
            END.

            CREATE tt_item.
            tt_item.tt_ItemCode = pt_part.
            tt_item.tt_Libelle = pt_desc1.
            tt_item.tt_Price = pt_price.
            tt_item.tt_Cost_Standard = totalStandard.
            tt_item.tt_Cost_Current = totalCurrent.
        END.

        FOR EACH tt_item NO-LOCK:
            DISPLAY
                tt_item.tt_ItemCode
                tt_item.tt_Libelle
                tt_item.tt_Price
                tt_item.tt_Cost_Standard
                tt_item.tt_Cost_Current
            WITH FRAME itemDetailsframe DOWN.
        END.

        file-name = output_dir + "itemDetailsTable_" + STRING(DAY(dt), "99") + STRING(MONTH(dt), "99") + STRING(YEAR(dt), "9999") + "_" + replace(string(time, "HH:MM:SS"), ":", "") + ".csv".

        OUTPUT TO VALUE(file-name).
        PUT UNFORMATTED "Item Number|Description|Item Price|Cost Std|Cost Crt".
        PUT UNFORMATTED SKIP.
        FOR EACH tt_item NO-LOCK:
            EXPORT DELIMITER "|" tt_item.
            IF ERROR-STATUS:ERROR THEN DO:
              MESSAGE "Error exporting tt_item: " + ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
              OUTPUT CLOSE.
              RETURN.
            END.
        END.
        IF NOT ERROR-STATUS:ERROR THEN DO:
            MESSAGE "Export to CSV successful."
            SKIP "File saved : " file-name VIEW-AS ALERT-BOX INFORMATION.
            OUTPUT CLOSE.
        END.

    end.

end.   