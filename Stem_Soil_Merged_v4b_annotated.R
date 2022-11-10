model{
  
  ##### Part 1 Soil Model: The soil model estimates missing values and 
  ## determines the proportion of pre-monsoon vs monsoon contributions to post-monsoon soil 
  ## moisture at depths 2 (10-30 cm) and 3 (30-60 cm). Soil depth 1 (0-10 cm) shows
  ## clear signs of evaporation and is included as a stem water source (see Part 2 below)
  ## but is not modeled in part 1.
  
  for(i in 1:Nsoil){
    ## Likelihood of post-monsoon soil water isotope data
    postd_soil[i,1:2] ~ dmnorm(mu_post[i,1:2], omega_soil[site.species_soil[tree_soil[i]],depth_soil[i],1:2,1:2])
    Y.rep_soil[i,1:2] ~ dmnorm(mu_post[i,1:2], omega_soil[site.species_soil[tree_soil[i]],depth_soil[i],1:2,1:2])
    
    ## Mixing model
    for(j in 1:2){
      ## Assumption: the isotopic signature of the monsoon rainfall is the same across all sites. 
      ## This assumption is based on weekly precipitation data from USNIP taken from 1989-2006 (USNIP active until 2012; CO91 measurements started in 1992).
      ## We chose 4 sites within the sampled region that were at sites similar in elevation to the 
      ## study sites (1600-3000 m).
      ## There were a total of 244 measurements during the monsoon across these 4 sites. The isotope values overlapped across the sites, so we 
      ## are comfortable making this assumption. 
      mu_post[i,j] <- (1-p[site.species_soil[tree_soil[i]],depth_soil[i]])*d_pre_cut[i,j] + 
        p[site.species_soil[tree_soil[i]],depth_soil[i]]*d_mu_monsoon[j]
      
      ## We applied a cut function to the pre- and post-monsoon soil isotopes such that the
      ## soil isotope missing data model is not influences by the soil and stem mixing
      ## models, but uncertainty in the imputed missing soil values is propagated to 
      ## the mixing models.
      d_pre_cut[i,j] <- cut(pred_soil[i,j])
      d_post_cut[i,j] <- cut(postd_soil[i,j])
    }
    
    ## Fill in missing pre-monsoon values submodel ##
    ## This model first fills in missing d18O values based on the estimated
    ## "mean" values for each site-species x depth combo, then it uses the estimated
    ## missing d18O to fill-in missing dD values based by the d18O-dD relationship.
    ## Associated priors for the submodel are: slope_pre, b_pre, and tau's. The slope
    ## and intercept vary by site type (1 = aspen, 2 = PJ)
    
    pred_soil[i,1] ~ dnorm(mu_dD_pre[i],tau_dD_pre) ##dD_pre
    mu_dD_pre[i] <- slope_pre[site.type_soil[i]]*pred_soil[i,2] + b_pre[site.type_soil[i]]
    pred_soil[i,2] ~ dnorm(mu_d18O_pre[site.species_soil[tree_soil[i]],depth_soil[i]], tau_d18O_pre) ##d18O_pre
  } 
  
  # Prior for the site-species-level p's, which are assumed to vary around the 
  # corresponding species of tree sampled; still vary by soil depth ID. 
  # Use a beta prior, which constrains p to [0,1].
  
  for(t in 1:Nsitespecies){
    for(d in 1:Ndepth){
      # Compute contribution of monsoon soil water:
      ## Prior for the contribution of monsoon soil water:
      p[t,d] ~ dbeta(a[species_soil[t],d], b[species_soil[t],d])
      # Compute contribution of pre-monsoon soil water:
      ppre[t,d] <- 1-p[t,d]
      
      for(j in 1:2){
        
        d_pre_site[t,d,j]  <- mean(d_pre_cut[sspIND1[t,d]:sspIND2[t,d],j])
        d_post_site[t,d,j] <- mean(d_post_cut[sspIND1[t,d]:sspIND2[t,d],j])
      
      }
      
    }
  }
  
  # Relatively non-informative priors for global parameters for the hierarchical p model.

  for(s in 1:Nspecies){
    for(d in 1:Ndepth){
      a[s,d] ~ dunif(1,100)
      b[s,d] ~ dunif(1,100)
      # Compute expected contribution of monsoon precip across all trees, for each
      # species and depth:
      Ep[s,d] <- a[s,d]/(a[s,d] + b[s,d])
      # Expected contribution of pre-monsoon soil water:
      Epre[s,d] <- 1 - Ep[s,d]
    }
  }
  
  # m loop for monsoon data (col 1 = dD; col 2 = d18O):
  for(m in 1:Nmonsoon){
    d_monsoon[m,1:2] ~ dmnorm(mu_monsoon[1:2], omega_monsoon[,])
  }

  ## We applied a cut function so that monsoon precip data only inform the monsoon
  ## end-member, and thus the end-member is not "adjusted" by the mixing models.
  d_mu_monsoon[1] <- cut(mu_monsoon[1]) # dD end-member
  d_mu_monsoon[2] <- cut(mu_monsoon[2])	# d18O end-member
  
  ##Prior for monsoon end-member
  
  for(j in 1:2){
    mu_monsoon[j] ~ dnorm(0,0.00001)
  }
  
  ## Priors for precision matrices
  
  ## 
  omega_monsoon[1:2,1:2] ~ dwish(R[1:2,1:2], 3)
  ## Compute covariance matrix
  sigma_monsoon[1:2,1:2] <- inverse(omega_monsoon[1:2,1:2]) 
  ## Compute correlation between D and 18O
  rho_monsoon <- sigma_monsoon[1,2]/sqrt(abs(sigma_monsoon[1,1])*abs(sigma_monsoon[2,2]))
  
  ## s loop (site), depth loop (k)
  for(s in 1:Nsitespecies){
    for(k in 1:Ndepth){
      omega_soil[s,k,1:2,1:2] ~ dwish(R[1:2,1:2], 3)
      omega_d_pre_soil[s,k,1:2,1:2] ~ dwish(R[1:2,1:2], 3) 
      sigma[s,k,1:2,1:2] <- inverse(omega_soil[s,k,1:2,1:2])
      rho[s,k] <- sigma[s,k,1,2]/sqrt(abs(sigma[s,k,1,1])*abs(sigma[s,k,2,2])) 
    }
  }
  
  ## Priors for soil isotope missing data model, for dD model:
  for(S in 1:NSiteType){
    slope_pre[S] ~ dnorm(0,0.001)
    b_pre[S] ~ dnorm(0,0.001)
  }
  tau_dD_pre   ~ dgamma(0.1,0.1)
  tau_d18O_pre ~ dgamma(0.1,0.1)
  
  ## Priors for soil isotope missing data model, for 18O model:
  for(s in 1:Nsitespecies){
    ## For soil depth 1, evaluate by site-species because there is likely variability
    ## between pinyons and junipers at the same site. 
    ## For intermediate and deep soil, evaluate by site because it is likely that 
    ## soil moisture is likely more uniform at greater depths with less evaporative
    ## influence.
    mu_d18O_pre[s,1] <- mu_d18O_pre_1[s]           
    mu_d18O_pre[s,2] <- mu_d18O_pre_2[Site_soil[s]]
    mu_d18O_pre[s,3] <- mu_d18O_pre_3[Site_soil[s]]
    ## Prior for pre-monsoon mean d18O of shallow layer:
    mu_d18O_pre_1[s] ~ dunif(-50,20)
  }
  
  ## Priors for pre-monsoon mean d18O of intermediate and deep layers:
  for(x in 1:Nsites){
    mu_d18O_pre_2[x] ~ dunif(-50,20)
    mu_d18O_pre_3[x] ~ dunif(-50,20)
  }
  
  ## End of Soil model -- start stem model  
  
  ###############################################################################
  
  ##### Part 2: Stem model: The stem model calculates the proportion of stem water 
  ## that comes from each layer during the pre- and post-monsoon sampling periods
  ## Nstem is the number of stem records (observations):
  
  ## Likelihood of stem isotope data. Modeling these as coming from a 
  ## multivariate normal to account for correlation (j = 1 (dD), j = 2 (d18O)). 
  ## And, assume pre- and post-monsoon isotope values are independent.
  ## Assume variance varies by site-species(tree(i)) and time code(k) 
  ## [pre(k=1), post(k=2)] -- and covariance 1:2:
  
  # STEM DATA
  for(i in 1:Nstem){
    ## data model (likelihood for pre-monsoon stem data):
    d_pre_stem[i,1:2] ~ dmnorm(mu_d_pre_stem[i,1:2],omega_pre[site.species[tree[i]],1:2,1:2]) 
    ## data model (likelihood for post-monsoon stem data):
    d_post_stem[i,1:2] ~ dmnorm(mu_d_post_stem[i,1:2],omega_post[site.species[tree[i]],1:2,1:2])
    
    ## replicated data for evaluating model fit:
    Y.rep_pre_stem[i,1:2] ~ dmnorm(mu_d_pre_stem[i,1:2],omega_pre[site.species[tree[i]],1:2,1:2]) 
    Y.rep_post_stem[i,1:2] ~ dmnorm(mu_d_post_stem[i,1:2],omega_post[site.species[tree[i]],1:2,1:2])
    
    ## Mixing model for pre- and post-monsoon isotope data. The relative contribution
    ## of different soil depths is given by p, which is assumed to vary by tree 
    ## and soil depth ID; dD and d18O share the same p's.
    
    ## We used cut values of soil isotopes to avoid feedback of stem model to soil 
    ## missing data model.
    
    for(j in 1:2){      
      for(d in 1:Ndepth){
        ## mean model (mixing model) components for pre-monsoon stem isotopes
        
        pred_delta[i,d,j]   <- p_pre[tree[i],d]*(p_tree[site.species[tree[i]]]*d_pre_cut[soilIND[tree[i],d],j] +
                                                   (1-p_tree[site.species[tree[i]]])*d_pre_site[site.species[tree[i]],d,j])
        
        ## mean model (mixing model) components for post-monsoon stem isotopes:

        postd_delta[i,d,j] <- p_post[tree[i],d]*(p_tree[site.species[tree[i]]]*d_post_cut[soilIND[tree[i],d],j] +
                                                   (1-p_tree[site.species[tree[i]]])*d_post_site[site.species[tree[i]],d,j])
      }
      
      # Mixing model, sum over depths:
      mu_d_pre_stem[i,j]  <- sum(pred_delta[i,,j])
      mu_d_post_stem[i,j] <- sum(postd_delta[i,,j])
    }
  }

  ###################################
  ## Model the relative contributions of water from different soil depths
  ## (i.e., the p_pre and p_post proportions in the stem mixing model)
  for(t in 1:Ntree){
    for(d in 1:3){
      ## Hierarchical gamma priors for the unnormalized contributions, u's,
      ## which results in a hierarchical Dirichlet prior for the actual contributions.
      u_pre[t,d] ~ dgamma(deltap_pre[site.species[t],d],1)
      u_post[t,d] ~ dgamma(deltap_post[site.species[t],d],1)

      # Calculate tree-level contributions:
      p_pre[t,d] <- u_pre[t,d]/denom_pre[t]
      p_post[t,d] <- u_post[t,d]/denom_post[t]
    }
    # Denominator for normalizing relative contributions:
    denom_pre[t] <- sum(u_pre[t,])
    denom_post[t] <- sum(u_post[t,])
  }
  
  for(s in 1:Nsitespecies){
    # Dirichelet prior for site-species level contributions from each depth.
    for(d in 1:Ndepth){ 
      # Compute actual contributions.
      Ep_pre_stem[s,d] <- deltap_pre[s,d]/sump_pre[s]
      Ep_post_stem[s,d] <- deltap_post[s,d]/sump_post[s]
      # Gamma trick for assigning dirichlet prior, hierarchical for site-species
      # around species.      
      deltap_pre[s,d] ~ dgamma(a_pre[species[s],d],1)    
      deltap_post[s,d] ~ dgamma(a_post[species[s],d],1)
    }
    
    p_tree[s] ~dbeta(a_tree[species[s]],b_tree[species[s]]) #a and b defined in species loop below
    
    sump_pre[s] <- sum(deltap_pre[s,])
    sump_post[s] <- sum(deltap_post[s,])
    
  }
  
  # Prior for species-level Dirichlet (gamma trick) parameter. 
  # Prior constrains a > 1.
  for(s in 1:Nspecies){
    for(d in 1:Ndepth){
      a_pre[s,d] ~ dunif(1,100)
      a_post[s,d] ~ dunif(1,100)
      
      ## Expected contributions at species level:
      Ep_pre_species[s,d] <- a_pre[s,d]/sum_a_pre[s]
      Ep_post_species[s,d] <- a_post[s,d]/sum_a_post[s]
      
      ## Difference in moisture sources (post-pre) at species level
      
      Ep_diff_species[s,d] <- Ep_post_species[s,d] - Ep_pre_species[s,d]
    }
    sum_a_pre[s] <- sum(a_pre[s,])
    sum_a_post[s] <- sum(a_post[s,])
    
    a_tree[s] ~ dunif(1,100)
    b_tree[s] ~ dunif(1,100)
    
    Ep_tree[s] <- a_tree[s]/(a_tree[s] + b_tree[s]) # expected contribution of tree-level (local) soil water to species s
  }

  
  #################################################################################### 
  
  ## END MODEL CODE BLOCK 
  
  ## In this section, we calculate the percent of the stem moisture that can be attributed to monsoon moisture
  ## (perc_mon_stem) at the site-species level and the difference in moisture sources (post-pre) at 
  ## the site-species level
  
  ## Percent monsoon contribution at the site-species level
  ## The 0-10 cm soil interval undergoes quite a bit of evaporation between rain events during the summer, and it is unlikely that there was 
  ## much (if any) winter or spring precip remaining by the time we re-sampled post-monsoon.
  ## We assumed that the monsoon contributed 100% of the moisture to the shallowest soil
  
  for(s in 1:Nsitespecies){
    perc_mon_stem[s] <- Ep_post_stem[s,1]*1 + Ep_post_stem[s,2]*p[s,2] + Ep_post_stem[s,3]*p[s,3] #p[s,1]
  }
  
  # Compute differences in soil contributions between period 2 (post) and 1 (pre-monsoon):
  for(s in 1:Nsitespecies){
    for(d in 1:Ndepth){
      # Compute differences by depths:
      Ep_diff_stem[s,d] <- Ep_post_stem[s,d] - Ep_pre_stem[s,d]
    }
    # Difference in total surface/subsurface contribution (not depth 3)
    Ep_diff_stem[s,4] <- sum(Ep_post_stem[s,1:2]) - sum(Ep_pre_stem[s,1:2])		
    # Difference in total subsurface/deep contribution (not depth 1)
    Ep_diff_stem[s,5] <- sum(Ep_post_stem[s,2:3]) - sum(Ep_pre_stem[s,2:3])		
  }
  
  ## priors for remaining precision matrices
  
  for(s in 1:Nsitespecies){
    omega_pre[s,1:2,1:2]    ~ dwish(R[1:2,1:2],3)
    omega_post[s,1:2,1:2]  ~ dwish(R[1:2,1:2],3)
    sigma_pre[s,1:2,1:2]     <- inverse(omega_pre[s,1:2,1:2])
    sigma_post[s,1:2,1:2]   <- inverse(omega_post[s,1:2,1:2])
    rho_pre[s]   <-sigma_pre[s,1,2]/sqrt(abs(sigma_pre[s,1,1])*abs(sigma_pre[s,2,2])) 
    rho_post[s]  <- sigma_post[s,1,2]/sqrt(abs(sigma_post[s,1,1])*abs(sigma_post[s,2,2])) 
  }
}