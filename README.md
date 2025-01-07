# Code for "Efficient Reinforcement Learning for Optimal Control with Natural Images" <br> [doi 10.48550/arXiv.2412.08893](https://arxiv.org/abs/2412.08893)

This code reproduces the figures in the journal article "Efficient Reinforcement Learning for Optimal Control with Natural Images". To run this code requires `Matlab`, although the crucial pieces of code should be clear enough to implement in any language. Download a snapshot of the repository's files as a zip file to your local computer, and then unpack the zip file. Reproducing the paper figures is broken down into the following two steps.

## Step 1. Make Natural Image Representations
Start `Matlab` and navigate into the `make_image_representations` directory. You will now run the file `convert_images.m` for each image representation, which will be written to the`image_data` directory. To do this you will need to carry out the following steps. In `convert_images.m`, there are four blocks of code corresponding to four different image representations. Un-comment a block of code (by removing each comment marker `%` in the block of code -- there is a button in the Matlab editor that does this for you when you highlight a block of comments) that corresponds to an image representation, then run `convert_images.m`. Make sure to add the comment markers back to the block before running the next block (use the `Matlab` button for this as well). 

When you get to the fourth code block, `4. Overcomplete sparse code`, you will need to edit the file `sparse_codes.m` to generate representations for three different degrees of overcompleteness. On lines 29 and 30 of `sparse_codes.m`, you will see 

`sqrt_number_of_gabors = 2*M;`

`output_filename = 'OC_Sparse_';`

These settings work for the first run, leading to the first overcomplete sparse code. For the second and third runs, use

2nd run: `sqrt_number_of_gabors = 4*M;`
`output_filename = 'OOC_Sparse_';`

3rd run: `sqrt_number_of_gabors = 8*M;`
`output_filename = 'OOOC_Sparse_';`

If you have a GPU available, you should also use

`W = gpuArray(make_Gabors(M^2, generate_samples(sqrt_number_of_gabors^2)));`

instead of

`W = make_Gabors(M^2, generate_samples(sqrt_number_of_gabors^2));`

In the directory `image_data`, you should now have the files: `cps201005032372.ppm`, `ImGDS_cps201005032372.txt`,`OC_upscaled_ImGDS_cps201005032372.txt`, `Whitened_ImGDS_cps201005032372.txt`, `OC_Sparse_ImGDS_cps201005032372.txt` `OOC_Sparse_ImGDS_cps201005032372.txt`,   and `OOOC_Sparse_ImGDS_cps201005032372.txt`.

## Step 2. Run the Reinforcement Learning Benchmark
If you have a GPU available, you should make the following change to line 12 of `RL_fitted_VI.m`: use

`v = gpuArray(zeros(RL.num_samples,sqrt_num_pixels^2)); `

instead of 

`v = zeros(RL.num_samples,sqrt_num_pixels^2);`

**Figure 3:** In file `paper_figures.m`, un-comment the block of code for Figure 3 and run the file. The plots corresponding to Figure 3 should appear. There is also the option to run `fitted_VI.m` (not shown in Figure 3) by un-commenting the appropriate code block. 

**Figure 4:** In file `paper_figures.m`, un-comment the block of code for Figure 4 (making sure to re-comment the Figure 3 block) and run the file. Again, there is the option to run `fitted_VI.m`not shown in Figure 4.

**Figure 5:** In file `paper_figures.m`, un-comment the block of code for Figure 5 and run the file.

The plot you just generated is for one image only (i.e., `number_of_images = 1;`). Figure 5 was constructed by averaging results over 48 images -- so it will look different to the plot you just generated. To precisely reconstruct Figure 5, you will need to download all 48 natural images from Set 5 of [https://natural-scenes.cps.utexas.edu/db.shtml](https://natural-scenes.cps.utexas.edu/db.shtml), and generate their image representations as in Step 1. The code is set up to do this provided the natural image files are placed in the `image_data` directory. However, the size of the directory will grow to around 700 GB, which is prohibitive for many systems. 

**Figure 6:** In file `paper_figures.m`, un-comment the block of code for Figure 6 and run the file. This will take around 40 minutes with a GPU. The plot you just generated is for one image only, while Figure 6 was constructed by averaging results over 48 images. To precisely reconstruct Figure 6, you can proceed as described for Figure 5.

**Figure 7:** In file `paper_figures.m`, un-comment the block of code for Figure 7 and run the file. This will take between 5 to 6 hours with a GPU. It only requires a single image, which is repeated for each time period.

**Figures 8 and 9:** In file `paper_figures.m`, un-comment the block of code for Figures 8 and 9 and run the file. This will take around 33 hours with a GPU due to the large number of states and time periods considered. In the code comments there are options to use fewer states for much faster run-times. These options are aligned sequentially in the comments. 

**Figure 10:** In file `paper_figures.m`, un-comment the block of code for Figure 10. You will also need to un-comment the block of code in `RL_benchmark.m` from lines 47--69. Now run `paper_figures.m`. This should take less than ten minutes with a GPU.

