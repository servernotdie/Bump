package io.github.slimefunguguproject.bump.implementation.tasks;

import javax.annotation.Nonnull;

import com.google.common.base.Preconditions;

import org.bukkit.entity.Projectile;

import io.github.slimefunguguproject.bump.implementation.Bump;
import io.github.slimefunguguproject.bump.utils.constant.Keys;
import io.github.thebusybiscuit.slimefun4.implementation.Slimefun;
import io.github.thebusybiscuit.slimefun4.libraries.dough.data.persistent.PersistentDataAPI;

/**
 * The {@link WeaponProjectileTask} is responsible for tracking
 * {@link Projectile} fired from Bump weapons.
 *
 * @author ybw0014
 */
@SuppressWarnings("ConstantConditions")
public final class WeaponProjectileTask {

    private static WeaponProjectileTask instance;

    private final int duration;

    public WeaponProjectileTask(int duration) {
        instance = this;
        this.duration = duration;
    }

    /**
     * This method starts this task
     */
    public static void start() {
        int duration = Bump.getRegistry().getConfig().getInt("weapons.projectile-duration", 0, 60);
        if (duration > 0) {
            instance = new WeaponProjectileTask(duration);
        }
    }

    /**
     * This method will add {@link Projectile} to tracking list.
     *
     * @param projectile the {@link Projectile} to be added.
     */
    public static void track(@Nonnull Projectile projectile) {
        Preconditions.checkArgument(projectile != null, "Projectile cannot not be null.");
        Preconditions.checkState(instance != null, "The task instance cannot be null.");
        instance.trackProjectile(projectile);
    }

    private void trackProjectile(Projectile projectile) {
        int spawnTick = Bump.getSlimefunTickCount();
        PersistentDataAPI.setBoolean(projectile, Keys.PROJECTILE, true);

        projectile.getScheduler().runAtFixedRate(Bump.getInstance(), task -> {
            if (!projectile.isValid() || spawnTick + duration < Bump.getSlimefunTickCount()) {
                if (projectile.isValid()) {
                    projectile.remove();
                }
                task.cancel();
            }
        }, null, 0L, Slimefun.getTickerTask().getTickRate());
    }
}
