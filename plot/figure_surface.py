from nilearn import plotting, image, masking  
import matplotlib.pyplot as plt
from nilearn import datasets
from nilearn import surface
from matplotlib import gridspec
import numpy as np
import pyvista as pv
from tqdm import tqdm
import pandas as pd
import matplotlib.cm as cm
from matplotlib.colors import ListedColormap, Normalize

img = image.load_img(['H:\\TSA_testCamcan\\FC\\T2.nii'])
n_samples = None
mask_img='D:\\DPABI_V6.0_210501\\Templates\\GreyMask_02_61x73x61.img'
mesh_file='D:\\freesurfer\\freesurfer\\subjects\\fsaverage5\\surf\\lh.pial'
inner_file='D:\\freesurfer\\freesurfer\\subjects\\fsaverage5\\surf\\lh.white'
texture = surface.vol_to_surf(
    img, mesh_file, interpolation='nearest', 
    mask_img=mask_img, kind='ball', radius=3, n_samples=n_samples)
plotting.plot_surf(mesh_file, texture,cmap=plt.get_cmap('RdYlBu_r'),colorbar=True,avg_method='mean')




mask_file = 'D:\\subcortex-master\\Group-Parcellation\\3T\\Subcortex-Only\\Tian_Subcortex_S1_3T.nii'

mask_file = 'C:\\Users\\dell\\Desktop\\lh_subcortex_renum.nii\\lh_subcortex_renum.nii'
# mask_file = 'masks/subcortex_mask_part1_cropped.nii'

msk = image.load_img(mask_file)
msk_data = msk.get_fdata()
msk_data[msk_data!=0]=1
affine = msk.affine

xlist, ylist, zlist = [], [], []
for x in tqdm(range(msk_data.shape[0])):
    for y in range(msk_data.shape[1]):
        for z in range(msk_data.shape[2]):
            if msk_data[x,y,z] == 1:
                select = True
                # for i in [-1, 0, 1]:
                #     for j in [-1, 0, 1]:
                #         for k in [-1, 0, 1]:
                #             if x+i < msk_data.shape[0] and x+i >= 0 and \
                #                y+j < msk_data.shape[1] and y+j >= 0 and \
                #                z+k < msk_data.shape[2] and z+k >= 0:
                #                 if msk_data[x+i,y+j,z+k] != 1:
                #                     select = True
                #             else:
                #                 select = True
                if select:
                    (xa, ya, za) = image.coord_transform(x, y, z, affine)
                    xlist.append(xa)
                    ylist.append(ya)
                    zlist.append(za)
points = np.array([xlist, ylist, zlist]).T

# convert point cloud in surface
cloud = pv.PolyData(points)
volume = cloud.delaunay_3d(alpha=3)
shell = volume.extract_geometry()
smooth = shell.smooth(n_iter=600, relaxation_factor=0.01,
                      feature_smoothing=False, 
                      boundary_smoothing=True,
                      edge_angle=100, feature_angle=100)

# extract faces
faces = []
i, offset = 0, 0
cc = smooth.faces 
while offset < len(cc):
    nn = cc[offset]
    faces.append(cc[offset+1:offset+1+nn])
    offset += nn + 1
    i += 1

# convert to triangles
triangles = []
for face in faces:
    if len(face) == 3:
        triangles.append(face)
    elif len(face) == 4:
        triangles.append(face[:3])
        triangles.append(face[-3:])
    else:
        print(len(face))

# create mesh
mesh = [smooth.points, np.array(triangles)]
cmap = plt.get_cmap('RdYlBu_r')
# eig_file = 'D:\\subcortex-master\\Group-Parcellation\\3T\\Subcortex-Only\\Tian_Subcortex_S1_3T.nii'
eig_file ='H:\\TSA_testCamcan\\FC\\T2.nii'
eig = image.load_img(eig_file)
texture = surface.vol_to_surf(eig, mesh, interpolation='nearest', radius=3, mask_img=mask_file)
plotting.plot_surf(mesh, texture, view='lateral', vmin=min(texture), vmax=max(texture),
                                cmap=cmap, avg_method='mean',colorbar=True)





import nibabel as nib
import numpy as np
import pyvista as pv
from skimage import measure

# 1. 读取nii文件
nii = nib.load(mask_file)
data = nii.get_fdata()
affine = nii.affine

# 2. 遍历每个标签值（1~8）
surfaces = []
for label in range(1, 10):
    # 创建该标签的掩码
    mask = (data == label).astype(np.uint8)

    # 3. 使用marching cubes提取surface
    verts, faces, _, _ = measure.marching_cubes(mask, level=0.5)

    # 将体素坐标转换为MNI空间坐标（使用affine变换）
    verts_world = nib.affines.apply_affine(affine, verts)

    # 4. 创建pyvista网格
    faces = np.hstack([np.full((faces.shape[0], 1), 3), faces]).astype(np.int32)  # 添加三角形面标识
    surface = pv.PolyData(verts_world, faces)
    surface = surface.smooth(n_iter=600, relaxation_factor=0.01, feature_smoothing=False)

    surface["label"] = np.full(verts_world.shape[0], label)
    surfaces.append(surface)

# 5. 合并并可视化
combined = surfaces[0]
for s in surfaces[1:]:
    combined += s

combined.plot(cmap="tab20", scalars="label")

# 使用 Plotter 改变展示方向
plotter = pv.Plotter()
plotter.add_mesh(combined, cmap="tab10", scalars="label", smooth_shading=True)

# 设置视角，例如从上往下（Z轴负方向）
plotter.view_vector((0, 0, -1))

# 显示
plotter.show()





import nibabel as nib
import numpy as np
import pyvista as pv
from skimage import measure

# 自定义标签对应的数值
label_to_value = {
    1: -0.10, 2: 0.15, 3: 0.20, 4: 0.25,
    5: 0.30, 6: 0.32, 7: 0.34, 8: 0.36,
    9: -0.38, 10:-0.40, 11: -0.42, 12: 0.44,
    13: 0.46, 14: 0.48, 15: 0.49, 16: 0.50
}

nii = nib.load(mask_file)
data = nii.get_fdata()
affine = nii.affine

surfaces = []

for label in range(1, 17):
    mask = (data == label).astype(np.uint8)

    if np.sum(mask) == 0:
        continue

    verts, faces, _, _ = measure.marching_cubes(mask, level=0.5)
    verts_world = nib.affines.apply_affine(affine, verts)

    faces = np.hstack([np.full((faces.shape[0], 1), 3), faces]).astype(np.int32)
    surface = pv.PolyData(verts_world, faces)
    surface = surface.smooth(n_iter=600, relaxation_factor=0.01, feature_smoothing=False)

    # 关键：每个点赋值为 label 对应的 value
    value = label_to_value[label]
    surface["value"] = np.full(surface.n_points, value)

    surfaces.append(surface)

# 合并并展示 value 上色
combined = surfaces[0]
for s in surfaces[1:]:
    combined += s

# 用 value 作为着色 scalar
plotter = pv.Plotter()
plotter.add_mesh(combined, scalars="value", cmap="RdYlBu_r", smooth_shading=True,clim=[-0.5, 0.5])
plotter.view_vector((-1, 0, 0))
plotter.show()
