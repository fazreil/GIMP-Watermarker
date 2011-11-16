; watermarking feature straight out of GIMP
; input: 	path of folder of the original images
;			watermark image
;			path of folder of the watermarked images
; output:	watermarked images in the given path

(define (MI-Watermarker watermark inputfolder outputfolder file)
; get the first image.
	(let *
		(;variable declarations
			;new layer for the image
			(ori (car (file-png-load 1 file file)))
			(img (car (gimp-image-new 100 100 RGB)))
			(imagewidth (/ (car(gimp-image-width (car(file-png-load 1 file file)))) 2) )
			(imageheight (/ (car(gimp-image-height (car(file-png-load 1 file file)))) 2) )
		)
		;set foreground color to white
		(gimp-palette-set-foreground '(255 255 255))

		;display the image
		(let *(
			(textlayer (car (gimp-text-fontname ori -1 (- imagewidth 100) (- imageheight 100) watermark 0 1 100 1 "Sans")))
			)
			(gimp-drawable-transform-rotate-default textlayer (- 0 0.7845) 1 imagewidth imageheight 1 0)
			(plug-in-bump-map 1 ori textlayer textlayer 135 45 3 0 0 0 0 1 0 0)
			(gimp-layer-set-opacity textlayer 50)
		)
		(gimp-display-new ori)
		
	)
	

)

(script-fu-register                                 ; I always forget these ...
   "MI-Watermarker"                                 ; script name to register
   "<Image>/Fazreil/WatermarkX"     				; where it goes
   "Watermarks the images found in the given path"  ; script description
   "Fazreil Amreen bin Abdul Jalil"                 ; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  		; copyright
   "2011-07-01"                                     ; date
   ""												; image type
   SF-STRING "Watermark" "Conto"      	            ; default parameters
   SF-DIRNAME "Original Image Directory" "/"
   SF-DIRNAME "Output folder" "/"
   SF-FILENAME "File input" "D:/karja/GIMPFU/Automation/Before/Homepage"
)
