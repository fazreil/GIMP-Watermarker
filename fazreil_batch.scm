; batch watermarking feature straight out of GIMP
; input: 	path of folder of the original images
;			watermark image
;			path of folder of the watermarked images
; output:	watermarked images in the given path

(define (get-file-width ori)
	(gimp-image-width ori)
)

(define (get-file-height ori)
	(gimp-image-height ori)
)

(define (center-watermark image textlayer)
	(gimp-layer-set-offsets textlayer (- (/ (car(gimp-image-width image)) 2) (/ (car(gimp-drawable-width textlayer)) 2)) (- (/ (car(gimp-image-height image)) 2) (/ (car(gimp-drawable-height textlayer)) 2)))
)

(define (watermark-size ori)
	(* (* (car(gimp-image-width ori)) (car(gimp-image-height ori))) 0.0001)
)

(define (stamp-watermark ori imagewidth imageheight watermark font size)
	(let* 
		(
			(textlayer (car (gimp-text-fontname ori -1 0 0 watermark 0 1 size 1 font)))
		)
		;move textlayer to top.
		(gimp-image-raise-layer-to-top ori textlayer)
		;rotate layer -45 degree
		(gimp-drawable-transform-rotate-default textlayer (- 0 0.7845) 1 imagewidth imageheight 1 0)
		;move the layer center
		(center-watermark ori textlayer)
		;stamp the textlayer to the original image
		(plug-in-bump-map 1 ori textlayer textlayer 135 45 3 0 0 0 0 1 0 0)
		;set opacity to 50%1
		(gimp-layer-set-opacity textlayer 40)
		(gimp-image-merge-down ori textlayer EXPAND-AS-NECESSARY)
	)
)

(define (MI-BWatermarker watermark inputfolder font size)
	(let*
		(
			(filelist (cadr(file-glob (string-append inputfolder "\\*.png") 0)))
		)
		(while (not(null? filelist))
			(let*
				(
					(filename (car filelist))
					(ori (car(file-png-load 1 filename filename)))
					(imagewidth (/ (car(get-file-width ori)) 2))
					(imageheight (/ (car(get-file-height ori)) 2))
				)
				;set foreground color to white
				(gimp-palette-set-foreground '(127 127 127))
				;(gimp-message filename)
				(stamp-watermark ori imagewidth imageheight watermark font size)
				;(gimp-display-new ori)
				(gimp-image-clean-all ori)
				(file-png-save-defaults 1 ori (car (gimp-image-get-active-layer ori)) filename filename)
			)
			(set! filelist (cdr filelist))
		)
		
	)
)

(script-fu-register                                 					; I always forget these ...
   "MI-BWatermarker"                                					; script name to register
   "<Image>/MIMOS/_MI-Watermarker (PNG)"								; where it goes
   "MIMOS Innovation: Watermarks the images found in the given path"  	; script description
   "Fazreil Amreen bin Abdul Jalil"                 					; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  							; copyright
   "2011-07-01"                                     					; date
   ""																	; image type
   SF-STRING "Watermark" "Sample"      	            					; default parameters
   SF-DIRNAME "Original Image Directory" "C:/karja/GIMPFU/Automation/Before"
   SF-FONT "Font type" "Sans"
   SF-ADJUSTMENT "Font Size" '(60 1 200 1 10 0 0)

)

(define (MI-JPGWatermarker watermark inputfolder font size)
	(let*
		(
			(filelist (cadr(file-glob (string-append inputfolder "\\*.jpg") 0)))
		)
		(while (not(null? filelist))
			(let*
				(
					(filename (car filelist))
					(ori (car(file-jpeg-load 1 filename filename)))
					(imagewidth (/ (car(get-file-width ori)) 2))
					(imageheight (/ (car(get-file-height ori)) 2))
				)
				;set foreground color to white
				(gimp-palette-set-foreground '(127 127 127))
				;(gimp-message filename)
				(stamp-watermark ori imagewidth imageheight watermark font size)
				;(gimp-display-new ori)
				(gimp-image-clean-all ori)
				(file-jpeg-save 	1		 	ori 	(car (gimp-image-get-active-layer ori))	filename 											filename 											1 0 0 0 "Copyright MIMOS 2011" 						1 1 0 1)
			)
			(set! filelist (cdr filelist))
		)
		
	)
)

(script-fu-register                                 					; I always forget these ...
   "MI-JPGWatermarker"                                					; script name to register
   "<Image>/MIMOS/_MI-Watermarker (JPG)"								; where it goes
   "MIMOS Innovation: Watermarks the images found in the given path"  	; script description
   "Fazreil Amreen bin Abdul Jalil"                 					; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  							; copyright
   "2011-07-01"                                     					; date
   ""																	; image type
   SF-STRING "Watermark" "Sample"      	            					; default parameters
   SF-DIRNAME "Original Image Directory" "C:/karja/GIMPFU/Automation/Before"
   SF-FONT "Font type" "Sans"
   SF-ADJUSTMENT "Font Size" '(60 1 200 1 10 0 0)
)

(define (MI-UWatermarker watermark inputfolder font size)
	;the ultimate watermarker utility
	(MI-JPGWatermarker watermark inputfolder font size)
	(MI-BWatermarker watermark inputfolder font size)
)

(script-fu-register                                 					; I always forget these ...
   "MI-UWatermarker"                                						; script name to register
   "<Image>/MIMOS/_MI-Watermarker (Utlimate)"										; where it goes
   "MIMOS Innovation: Watermarks the images found in the given path"  	; script description
   "Fazreil Amreen bin Abdul Jalil"                 					; author
   "Copyright 2011 by Fazreil.jalil; GNU GPL"  							; copyright
   "2011-07-01"                                     					; date
   ""																	; image type
   SF-STRING "Watermark" "Sample"      	            					; default parameters
   SF-DIRNAME "Original Image Directory" "C:/karja/GIMPFU/Automation/Before"
   SF-FONT "Font type" "Sans"
   SF-ADJUSTMENT "Font Size" '(60 1 200 1 10 0 0)
)