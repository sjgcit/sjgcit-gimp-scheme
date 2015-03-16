
; filllight.scm
;
; (c) Stephen Geary, Dec 2012
;
; $Id: fillight.scm,v 1.4 2015/03/16 18:32:27 sjg Exp $
;
; Add a duplicate layer with an inverse greyscale mask
; to allow quick fill light operations.
;
; 1. Duplicate the layer
; 2. Add a layer mask from the inverse greyscale of the duplicate layer
; 3. Select the image of duplicate layer ( not the mask )
;

(define (script-fillight
                image
                drawable
                )

    (gimp-undo-push-group-start image)


    (let*
        (
            (filllayer (car (gimp-layer-copy drawable TRUE)))

            (fillmask (car (gimp-layer-create-mask filllayer 5)))
        )
        
        (gimp-layer-add-mask filllayer fillmask)

        (gimp-image-add-layer image filllayer -1)

        (gimp-image-set-active-layer image filllayer)
        
        (gimp-layer-set-edit-mask filllayer FALSE)
        
        (gimp-invert fillmask)
        
        (gimp-displays-flush)
    )

    (gimp-undo-push-group-end image)
)

(script-fu-register    "script-fillight"
            "<Image>/Colors/Auto/Fill Light"
            "Add a layer suitable as a fill light mask"
            ""
            "Stephen Geary"
            "2012-Dec-3"
            ""
            SF-IMAGE "Image" 0
            SF-DRAWABLE "Drawable" 0
)
