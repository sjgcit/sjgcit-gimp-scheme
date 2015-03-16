
; EdgeMask.scm
;
; (c) Stephen Geary, Mar 2011
;
; $Id: edgemask.scm,v 1.1 2011/04/14 12:22:46 sjg Exp $
;
; Create a mask to avoid edges being affected
;

;==========================================================================

(define (script-edge-mask
				image
				drawable
				)

	(gimp-undo-push-group-start image)


	(let*
		(
			(newmask (car (gimp-layer-create-mask drawable 5)))
		)

		(gimp-layer-add-mask drawable newmask)

		(plug-in-edge 1 image newmask 1.0 1 0)

		(gimp-invert newmask)

		(gimp-displays-flush)
	)

	(gimp-undo-push-group-end image)
)

;==========================================================================

(define (script-sharp-layer
				image
				drawable
				amount
				)

	(gimp-undo-push-group-start image)

	(let*
		(
			(newlayer (car (gimp-layer-copy drawable TRUE)))
			(newmask (car (gimp-layer-create-mask newlayer 5)))
		)

		(gimp-layer-add-mask newlayer newmask)
		(gimp-image-add-layer image newlayer -1)

		(plug-in-edge 1 image newmask 1.0 1 0)
		(gimp-invert newmask)
		(plug-in-gauss 1 image newmask 5.0 5.0 1)

		(gimp-image-set-active-layer image newlayer)

		(plug-in-unsharp-mask 1 image newlayer 0.1 amount 1)

		(gimp-layer-set-opacity newlayer 50.0)
	)

	(gimp-undo-push-group-end image)
)

;==========================================================================

(script-fu-register	"script-edge-mask"
			"<Image>/Layer/Edge Mask"
			"Add a layer mask based on the inverse of the edge of the greyscale of the layer"
			""
			"Stephen Geary"
			"2011-Mar-17"
			""
			SF-IMAGE "Image" 0
			SF-DRAWABLE "Drawable" 0
)

;==========================================================================

(script-fu-register	"script-sharp-layer"
			"<Image>/Filters/Enhance/Sharp Layer"
			"USM Sharpen using a small amount but a large radius and apply a blurred edge mask"
			""
			"Stephen Geary"
			"2011-Apr-14"
			""
			SF-IMAGE "Image" 0
			SF-DRAWABLE "Drawable" 0
			SF-VALUE "Amount" "4.0"
)
