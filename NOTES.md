NOTES
===

1. There was a question about how we pass geometry/gid into the views. Currently we use GID, that means that the 
correct geometry (4258/25833) can be looked up by the view. We maintain pre-projected geometry for all datasets for
performance.

2. GBB: have added the Google/Bing webmaps projection, using it as the default for WMS output

3. Checking overview files: are they adding up the right layers, and being 
divided by the right number? Currently this is set manually per overview. 
A simple weighted average is used but other weightings can be easily 
applied. e.g. (view_3_1_1 + view_3_3_1)/2 <-- 2 layers, so divide by 2.

4. Checking views: check performance during a non-parallel build to make 
sure the new layer is not blocking the entire build.


