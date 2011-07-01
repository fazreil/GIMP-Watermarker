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
			(img (car (gimp-image-new 10 10 RGB)))
			(ori (car (file-png-load 1 file file)))
			;(text (car (gimp-text-fontname -1 -1 (/ (gimp-image-height ori) 2) (/ (gimp-image-width ori) 2) watermark 0 1 10 1 "Sans")))

		)
		;display the image
		(gimp-display-new ori)
		(gimp-text-fontname -1 -1 (/ (gimp-image-height ori) 2) (/ (gimp-image-width ori) 2) watermark 0 1 10 1 "Sans")
	)

)

(script-fu-register                                 ; I always forget these ...
   "MI-Watermarker"                                 ; script name to register
   "<Image>/MIMOS/Watermark"     					; where it goes
   "Watermarks the images found in the given path"  ; script description
   "Fazreil Amreen bin Abdul Jalil"                 ; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  		; copyright
   "2011-07-01"                                     ; date
   ""												; image type
   SF-STRING "Watermark" "Conto"      	            ; default parameters
   SF-DIRNAME "Original Image Directory" "/"
   SF-DIRNAME "Output folder" "/"
   SF-FILENAME "File input" "/karja/GIMPFU/Automation/Before"
)
