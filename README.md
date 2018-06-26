# Correct disortion with lensfun and imagemagick

Simple bash script to automate the [lens disortion](http://www.imagemagick.org/Usage/lens/) correction process. Idea was to use with [Termux](https://play.google.com/store/apps/details?id=com.termux&hl=en_IN) on my mobile.

Note: Lens and their params are [hardcoded](https://github.com/palaniraja/lens/blob/master/lens.sh#L28)

## Customization
* You have to find your own lens configuration from from [lensfun](https://github.com/lensfun/lensfun/blob/master/data/db/slr-canon.xml). eg., I have extracted values for [my lens](https://gist.github.com/palaniraja/958216b7fce9aaa48e96cef16dc66ef9)
* Use the values to update `lensParam` in functions 
* Also have to update the `if` conditions according to your `lens...`


### Usage

```
$./lens.sh forig2.jpg
Analysing file ... forig2.jpg
-------
Model: Canon EF 50mm f/1.8 STM
Focal Length: 50.0 mm
-------
It is a 50mm lens @ 50.0 mm
Param for ptLens=50 to be used ... (0.0061844 -0.0313122 0.0314815)
Processing with imagemagick ... [ DONE ]
Output file: corrected-forig2.jpg
```


![command usage](screenshot.png)


## Imagemagick command demo

[![Youtube video](https://img.youtube.com/vi/Ihd6r9h-TO8/0.jpg)](https://www.youtube.com/watch?v=Ihd6r9h-TO8)
