; batch watermarking feature straight out of GIMP
; input: 	path of folder of the original images
;			watermark image
;			path of folder of the watermarked images
; output:	watermarked images in the given path

(define (get-file-width file)
	(gimp-image-width (car(file-png-load 1 file file)))
)

(define (get-file-height file)
	(gimp-image-height (car(file-png-load 1 file file)))
)

(define (stamp-watermark ori imagewidth imageheight watermark)
	(let* 
		(
			(textlayer (car (gimp-text-fontname ori -1 (- imagewidth 100) (- imageheight 100) watermark 0 1 100 1 "Sans")))
		)
		;rotate layer -45 degree
		(gimp-drawable-transform-rotate-default textlayer (- 0 0.7845) 1 imagewidth imageheight 1 0)
		;stamp the textlayer to the original image
		(plug-in-bump-map 1 ori textlayer textlayer 135 45 3 0 0 0 0 1 0 0)
		;set opacity to 50%1
		(gimp-layer-set-opacity textlayer 50)
		(gimp-image-merge-down ori textlayer EXPAND-AS-NECESSARY)
	)
)

(define (MI-BWatermarker watermark inputfolder outputfolder file)
	(let*
		(
			(filelist (cadr(file-glob (string-append inputfolder "\\*.png") 1)))
		)
		(while (not(null? filelist))
			(let*
				(
					(filename (car filelist))
					(ori (car(file-png-load 1 filename filename)))
					(imagewidth (/ (car(get-file-width filename)) 2))
					(imageheight (/ (car(get-file-height filename)) 2))
				)
				;set foreground color to white
				(gimp-palette-set-foreground '(255 255 255))
				(stamp-watermark ori imagewidth imageheight watermark)
				;(gimp-display-new ori)
				(gimp-image-clean-all ori)
				(file-png-save-defaults 1 ori (car (gimp-image-get-active-layer ori)) filename filename)
			)
			(set! filelist (cdr filelist))
		)
		
	)
)

(script-fu-register                                 ; I always forget these ...
   "MI-BWatermarker"                                ; script name to register
   "<Image>/MIMOS/BWatermarker"     				; where it goes
   "Watermarks the images found in the given path"  ; script description
   "Fazreil Amreen bin Abdul Jalil"                 ; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  		; copyright
   "2011-07-01"                                     ; date
   ""												; image type
   SF-STRING "Watermark" "Conto"      	            ; default parameters
   SF-DIRNAME "Original Image Directory" "C:/karja/GIMPFU/Automation/Before"
   SF-DIRNAME "Output folder" "C:/karja/GIMPFU/Automation/Test"
   SF-FILENAME "File input" "C:/karja/GIMPFU/Automation/Before/Homepage.PNG"
)

(define (LoopaDemo watermark inputfolder outputfolder file)
	(let* 
		(
			(filelist (cadr(file-glob (string-append inputfolder "\\*.png") 1)))
		)
		(while (not (null? filelist))
				(let*
					(
						(filename (car filelist))
					)
					(gimp-message filename)
					(set! filelist (cdr filelist))
				)
		)
		
	)
)
(script-fu-register                                 ; I always forget these ...
   "LoopaDemo"           		                    ; script name to register
   "<Image>/MIMOS/L_oopa"     						; where it goes
   "Watermarks the images found in the given path"  ; script description
   "Fazreil Amreen bin Abdul Jalil"                 ; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  		; copyright
   "2011-07-01"                                     ; date
   ""												; image type
   SF-STRING "Watermark" "Conto"      	            ; default parameters
   SF-DIRNAME "Original Image Directory" "C:/karja/GIMPFU/Automation/Before"
   SF-DIRNAME "Output folder" "C:/karja/GIMPFU/Automation/Test"
   SF-FILENAME "File input" "C:/karja/GIMPFU/Automation/Before/Homepage.PNG"
)